//
//  ItemViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var arrayOfProducts = [ProductModel]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfProducts = arrayOfProducts.sortProductByName(.orderedAscending) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfProducts.count
    }
    @objc func sliderValueChanged(sender: UISlider){
        arrayOfProducts[sender.tag].count = Int(sender.value)
        UIView.performWithoutAnimation {
            self.collectionView.reloadItems(at:[IndexPath.init(row: sender.tag, section: 0)])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        let product = arrayOfProducts[indexPath.row]

        cell.productCategory.text = product.category
        cell.productName.text = product.name
        //MARK: be dynamic formats number to the €,$ as soo on
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: product.price! as NSNumber) {
             cell.productPrice.text = formattedTipAmount
        }
        cell.productAmount.text = String(product.count!)
        if (product.image != nil) {
            cell.productImage.image = product.image!
        }
        
        cell.amountSlider.tag = indexPath.row // Use tag to see which cell your slider is located
        cell.amountSlider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
        cell.amountSlider.value = Float(product.count!)

        cell.productDetail.text = product.details!
        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10 // optional
        
        return cell
    }

    @IBAction func addProduct(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(.zero, to: self.collectionView)
        let indexPath:IndexPath = self.collectionView.indexPathForItem(at: buttonPosition)!
        let productA = arrayOfProducts[indexPath.row]
        
        if (productA.count! > 0){
            let productB = productA.copy() as! ProductModel

            let alert = UIAlertController(title: "Details?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "abbrechen", style: .cancel, handler: nil))
            
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Details ..."
            })
            
            alert.addAction(UIAlertAction(title: "hinzufügen", style: .default, handler: { action in
                
                if let name = alert.textFields?.first?.text {
                    productB.details = name
                    orderedProducts.append(productB)

                    //reset to 0
                    productA.count = 0
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadItems(at:[indexPath])
                    }
                    
                    if let tabItems = self.tabBarController?.tabBar.items as NSArray?
                    {
                        // In this case we want to modify the badge number of the third tab:
                        let tabItem = tabItems[0] as! UITabBarItem
                        tabItem.badgeValue = String(orderedProducts.count)
                    }
                }
            }))
            
            self.present(alert, animated: true)

           
        } else {
            //Give a dialog out to show a dialog
            let alert = UIAlertController(title: "Menge angeben", message: "Bitte gebe die Menge durch den Schieberegler ein.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "verstanden", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
      
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

}

