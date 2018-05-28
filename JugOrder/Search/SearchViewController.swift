//
//  SearchViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let searchController = UISearchController(searchResultsController: nil)

    private var arrayOfProducts : [ProductModel] = []
    @IBOutlet weak var collectionView: UICollectionView!
    private var filteredArrayOfProducts : [ProductModel] = []
    var isFiltering: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Suche ..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Hookah", "Drinks", "Snacks"]
        searchController.searchBar.delegate = self
        
        //navigationController?.navigationBar.prefersLargeTitles = true
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
    
    @IBAction func addProduct(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(.zero, to: self.collectionView)
        let indexPath:IndexPath = self.collectionView.indexPathForItem(at: buttonPosition)!
        var product = ProductModel()
        if isFiltering {
            product = filteredArrayOfProducts[indexPath.row]

        } else {
            product = arrayOfProducts[indexPath.row] 

        }
        
        orderedProducts.append(product)
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
extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
