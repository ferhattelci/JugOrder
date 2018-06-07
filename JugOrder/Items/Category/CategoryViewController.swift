//
//  CategoryViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit


class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var arrayOfCategories = [(key: CategoryModel, value: [ProductModel])]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return arrayOfCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell

        //let product = Array(arrayOfCategories.keys)[indexPath.row]
        let product = arrayOfCategories[indexPath.row]
        cell.categoryName.text = product.key.name!
        if product.key.image != nil {
            cell.categoryImage.image = product.key.image!
        }
        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8 // optional
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let key = Array(arrayOfCategories.keys)[indexPath.row]
        let key = arrayOfCategories[indexPath.row]

        let products = key.value
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ItemsViewController") as! ItemsViewController
        viewController.arrayOfProducts = products
        viewController.category = key.key
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    



}
extension Array where Element: ProductModel {
    //This method only takes an order type. i.e ComparisonResult.orderedAscending
    func sortProductByName(_ order: ComparisonResult) -> [ProductModel] {
        let sortedArray = self.sorted { (product1, product2) -> Bool in
            return product1.checkForOrder(product2, order)
        }
        return sortedArray
    }
}
