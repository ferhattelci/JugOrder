//
//  CategoryViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit


class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var arrayOfCategories = [String: NSMutableArray]()

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
        let product = Array(arrayOfCategories.keys)[indexPath.row]
        
        cell.categoryName.text = product
        
        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8 // optional
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = Array(arrayOfCategories.keys)[indexPath.row]
        let products = arrayOfCategories[key]
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ItemsViewController") as! ItemsViewController
        viewController.arrayOfProducts = products!
        viewController.category = key
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    



}
