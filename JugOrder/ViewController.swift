//
//  ViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 30.03.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

var orderedProducts : [ProductModel] = []
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderTable: UITableView!
    var selectedTable = TableModel()
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedTable.name!
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view, typically from a nib.
        orderButton.layer.borderColor = UIColor.lightGray.cgColor
        orderButton.layer.borderWidth = 1
        orderButton.layer.cornerRadius = 10 // optional
        
        

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
        if (orderedProducts.count > 0){
            orderButton.isHidden = false
        } else {
            orderButton.isHidden = true
        }
    }

    @IBAction func takeOrder(_ sender: Any) {
        //Bestellung durchgehen
        for product in orderedProducts {
            
            
        }

        
    }
    //MARK TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewTableViewCell
        let product = orderedProducts[indexPath.row] 
        cell.delegate = self
        
        cell.productCategory.text = product.category
        cell.productDetails.text = product.details
        cell.productTitle.text = product.name
        cell.productPrice.text = String(product.price!) + " €"
        cell.productAmount.text = "Menge " + String(product.count!)
        if product.image != nil{
            cell.productImage.image = product.image!
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            orderedProducts.remove(at: indexPath.row)
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
        print("doubleTap \(String(describing: indexPath)) ")
}
}
