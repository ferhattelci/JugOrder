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
        navigationController?.navigationBar.prefersLargeTitles = true

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
        var productA = ProductModel()
        if isFiltering {
            productA = filteredArrayOfProducts[indexPath.row]

        } else {
            productA = arrayOfProducts[indexPath.row]

        }
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
    
    
    @objc func sliderValueChanged(sender: UISlider){
        if isFiltering {
            filteredArrayOfProducts[sender.tag].count = Int(sender.value)
        } else {
            arrayOfProducts[sender.tag].count = Int(sender.value)
        }
        
        // collectionView.reloadItems(at: [indexPath])

        UIView.performWithoutAnimation {
            self.collectionView.reloadItems(at:[IndexPath.init(row: sender.tag, section: 0)])
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        let product = object(at: indexPath)
        
        cell.productCategory.text = product.category
        cell.productName.text = product.name
        cell.productPrice.text = String(product.price!) + " €"
        cell.productAmount.text = String(product.count!)
        if (product.image != nil) {
            cell.productImage.image = product.image!
        }
        cell.amountSlider.tag = indexPath.row // Use tag to see which cell your slider is located
        cell.amountSlider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
        cell.amountSlider.value = Float(product.count!)

        
        
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
