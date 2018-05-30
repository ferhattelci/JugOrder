//
//  TableViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedSegment = "EG"
    var selectedTable = TableModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup Segment
        let segment: UISegmentedControl = UISegmentedControl(items: ["EG", "Playroom", "OG"])

        segment.sizeToFit()
        segment.tintColor = .jugWhite
        segment.selectedSegmentIndex = 0;
        segment.addTarget(self, action: #selector(segmentedControlValueChanged), for: UIControlEvents.valueChanged)
        segment.addTarget(self, action: #selector(segmentedControlValueChanged), for: UIControlEvents.touchUpInside)

        self.navigationItem.titleView = segment
        // Do any additional setup after loading the view.

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func segmentedControlValueChanged(segment: UISegmentedControl){
        if segment.selectedSegmentIndex == 0 {
            selectedSegment = "EG"
        }
        else if segment.selectedSegmentIndex == 1 {
            selectedSegment = "Playroom"
        }
        else if segment.selectedSegmentIndex == 2 {
            selectedSegment = "OG"
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (Tables[selectedSegment]?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TableCollectionViewCell
        
        //let product = Array(arrayOfCategories.keys)[indexPath.row]
        let table = Tables[selectedSegment]
        cell.tableName.text = table![indexPath.row].name
        cell.tableImage.image = #imageLiteral(resourceName: "tableFree")
        cell.tablePrice.text = "10,99 €"
        cell.tableTimer.text = "00:20"
        
        
        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8 // optional
        
        
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "orderSegue") {
            let buttonPosition:CGPoint = (sender as AnyObject).convert(.zero, to: self.collectionView)
            let indexPath:IndexPath = self.collectionView.indexPathForItem(at: buttonPosition)!
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let navCtrl: UINavigationController = tabCtrl.viewControllers![0] as! UINavigationController
            let vc = navCtrl.viewControllers[0] as! ViewController
            
            let key = Tables[selectedSegment]
            let table = key![indexPath.row]
            vc.selectedTable = table
        }
    }

    


}
