//
//  DrinkViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UIView!

    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CategoryViewController
        {
            let vc = segue.destination as? CategoryViewController
            let keys:[String: [ProductModel]] = Products["Drinks"]!

            let sortedKeys = keys.sorted(by: { $0.key < $1.key })
            vc?.arrayOfCategories = sortedKeys
        }
    }

}
