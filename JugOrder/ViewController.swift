//
//  ViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 30.03.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit
import UserNotifications
import NavBarDropdownMenu

var orderedProducts : [String: [ProductModel]] = [:]

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navOptionView: UIBarButtonItem!
    var selectedTable = TableModel()
    var orderTable = OrderModel()

    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedTable.name! + " - " + selectedTable.category!
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view, typically from a nib.
        orderButton.layer.borderColor = UIColor.lightGray.cgColor
        orderButton.layer.borderWidth = 1
        orderButton.layer.cornerRadius = 10 // optional
        
        //init orderedProducts dict
        orderedProducts.removeAll()
        orderedProducts.updateValue([ProductModel](), forKey: "aktuelle Bestellung")
        orderedProducts.updateValue([ProductModel](), forKey: "ausstehende Bestellung")
        
        //get data for this table
        if !((selectedTable.orderedDate?.isEmpty)!) {
            TableModel.downloadTable(id: String(selectedTable.id!)) { (result) in
                orderedProducts["ausstehende Bestellung"] = result
                self.tableView.reloadData()
            }
        }
        
        //init drop down menu
        let items = ["umbuchen", "bezahlen"]
        
        let menuView = BTNavigationDropdownMenu.init(title: ". . .", items: items)
        self.navOptionView.customView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("select")
            if indexPath == 0 {
                if self?.orderTable.id != nil {
                    self?.reBook()
                }
            }
            else {
                
            }
        }
        menuView.shouldChangeTitleText = false
        
        //init order
        orderTable.TableID = selectedTable.id
        orderTable.EmployeeID = activeUser.id
        
        orderTable.readOrder { (order) in
            
        }
    }
    
    func reBook(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "TableNavigationController") as! UINavigationController
        let destinationNavigationController = navController.viewControllers[0] as! TableViewController
        destinationNavigationController.reBook = true
        destinationNavigationController.reBookOrder = orderTable

        
        present(navController, animated: true, completion: nil)
        
    }
    
    func pay(){
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        checkDataExist()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkDataExist(){
        if (orderedProducts["aktuelle Bestellung"]!.count > 0){
            orderButton.isHidden = false
        } else {
            orderButton.isHidden = true
        }
    }
    

    @IBAction func takeOrder(_ sender: Any) {
        //Bestellung durchgehen
        orderTable.readOrder { (order) in
            if (self.orderTable.id == nil){
                self.orderTable.createOrder(pproducts: orderedProducts["aktuelle Bestellung"]!)
            } else {
                self.orderTable.createOrderItems(pProducts: orderedProducts["aktuelle Bestellung"]!)
            }
            
            self.timedNotifications(selectedTable: self.selectedTable, inSeconds: 600) { (success) in
                if (success) {
                    print("Erfolgreich")
                }
            }
            
            var newArray = [ProductModel]()
            newArray = orderedProducts["aktuelle Bestellung"]!
            newArray = newArray + orderedProducts["ausstehende Bestellung"]!
            
            
            orderedProducts["ausstehende Bestellung"] = newArray
            orderedProducts["aktuelle Bestellung"]?.removeAll()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.checkDataExist()
                
            }
        }
    }

    
    //MARK Notification
    
    func timedNotifications(selectedTable : TableModel, inSeconds: TimeInterval, completion: @escaping (_ Success:Bool) -> ()){
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: inSeconds, repeats: false)

        let content = UNMutableNotificationContent()
        
        content.title = ""
        content.subtitle = ""
        content.body = "Die letzte Bestellung von " + selectedTable.name! + " ist 10 min her."
        
        let request = UNNotificationRequest.init(identifier: stringWithUUID(), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    func stringWithUUID() -> String {
        let uuidObj = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuidObj)!
        return uuidString as String
    }
    //MARK TABLE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(orderedProducts.keys.sorted())[section]
        
        return (orderedProducts[key]?.count)!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderedProducts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(orderedProducts.keys.sorted())[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewTableViewCell
        let key = Array(orderedProducts.keys.sorted())[indexPath.section]
        let products = orderedProducts[key]!.sorted(by: { $0.name! < $1.name! })
        
        let product = products[indexPath.row]
        cell.delegate = self
        
        cell.productCategory.text = product.category
        cell.productDetails.text = product.details
        cell.productFinished.isHidden = true

        if product.Status != nil {
            if product.Status! == product.count! {
                cell.productFinished.isHidden = false
            }
        }
        cell.productTitle.text = product.name
        //MARK: be dynamic formats number to the €,$ as soo on
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: product.price! as NSNumber) {
            cell.productPrice.text = formattedTipAmount
        }
        cell.productAmount.text = "Menge " + String(product.count!)
        if product.image != nil{
            cell.productImage.image = product.image!
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let key = Array(orderedProducts.keys)[indexPath.section]
            orderedProducts[key]!.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if let tabItems = self.tabBarController?.tabBar.items as NSArray?
            {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[0] as! UITabBarItem
                tabItem.badgeValue = String(orderedProducts.count)
            }
            
            checkDataExist()
        }
    }
    
}
extension ViewController:TableViewCellDelegate {
    
    
    func tableViewCell(singleTapActionDelegatedFrom cell: ViewTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        print("singleTap \(String(describing: indexPath)) ")
    }
    
    func tableViewCell(doubleTapActionDelegatedFrom cell: ViewTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let key = Array(orderedProducts.keys)[(indexPath?.section)!]
        let product = orderedProducts[key]![(indexPath?.row)!]
        orderedProducts["aktuelle Bestellung"]?.append(product)
        print("doubleTap \(String(describing: indexPath)) ")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
}
}
