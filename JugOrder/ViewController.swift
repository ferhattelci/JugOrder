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
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewTableViewCell
        let product = orderedProducts[indexPath.row]
        
        cell.productCategory.text = product.category
        cell.productDetails.text = "Details"
        cell.productTitle.text = product.name
        cell.productPrice.text = String(product.price!) + " €"
        
        return cell
    }
    

    @IBOutlet weak var orderTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

