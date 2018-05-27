//
//  ItemsViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {

    var category = String()
    var arrayOfProducts = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = category

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
