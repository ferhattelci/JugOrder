//
//  ItemViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var arrayOfProducts = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfProducts.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        let product = arrayOfProducts[indexPath.row] as! ProductModel
        
        
        cell.productCategory.text = product.category
        cell.productDetails.text = "Details"
        cell.productName.text = product.name
        cell.productPrice.text = String(product.price!) + " €"
        
        
        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10 // optional
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}
