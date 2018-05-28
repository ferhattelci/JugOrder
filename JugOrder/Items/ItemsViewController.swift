//
//  ItemsViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController, UISearchBarDelegate {

    var category = String()
    var arrayOfProducts = [ProductModel]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category
     
        navigationController?.navigationBar.prefersLargeTitles = true

        //Setup Segment
        let segment: UISegmentedControl = UISegmentedControl(items: ["Alle", "Favoriten"])
        segment.sizeToFit()
        segment.tintColor = .jugRed
        segment.selectedSegmentIndex = 0;
     
        self.navigationItem.titleView = segment
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Suche ..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the Scope Bar
       // searchController.searchBar.scopeButtonTitles = ["All", "Hookah", "Drinks", "Snacks"]
        searchController.searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ItemViewController
        {
            let vc = segue.destination as? ItemViewController
            vc?.arrayOfProducts = arrayOfProducts
        }
    }

}
extension ItemsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
