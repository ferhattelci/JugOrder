//
//  HookahViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class HookahViewController: UIViewController {
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var hookahView: UIView!
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

            var compare = Products["Hookah"]!
            let compare2 = Products["Tabak"]!

            compare.update(other: compare2)

            let values:[CategoryModel: [ProductModel]] = compare

            let sortedKeys = values.sorted(by: { $0.key.name! < $1.key.name! })
            vc?.arrayOfCategories = sortedKeys

        }

    }
   
}
extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

