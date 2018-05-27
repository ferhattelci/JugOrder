//
//  SearchViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {


    private var arrayOfProducts : [ProductModel] = []
    @IBOutlet weak var collectionView: UICollectionView!
    private var filteredArrayOfProducts : [ProductModel] = []
    var isFiltering: Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        arrayOfProducts = allProducts
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchTerm: searchText)
        collectionView.reloadData()
        
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredArrayOfProducts.count
        } else {
            return arrayOfProducts.count
        }
    }
    func filter(searchTerm: String){
        if searchTerm.isEmpty {
            isFiltering = false
            filteredArrayOfProducts.removeAll()
        } else {
            isFiltering = true
            
            filteredArrayOfProducts = arrayOfProducts.filter({
                return ($0.name?.localizedCaseInsensitiveContains(searchTerm))!
            })
        }
    }
    
    func object(at indexPath: IndexPath) -> ProductModel{
        if isFiltering {
            return filteredArrayOfProducts[indexPath.row]
        } else {
            return arrayOfProducts[indexPath.row]
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        let product = object(at: indexPath)
        
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
    


}
