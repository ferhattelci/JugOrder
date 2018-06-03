//
//  TableViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HomeModelProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedSegment = "EG"
    var selectedTable = TableModel()
    let refreshControl = UIRefreshControl()

    var timer : Timer?
    let homeModel = DataModel()
    
    func downloadedAllData() {
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
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

        homeModel.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        refreshControl.tintColor = .jugYellow
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true

    }
    
    @objc func refresh(){
        print("refresh")
        homeModel.downloadAllData()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateCells),
                                     userInfo: nil, repeats: true)
        homeModel.downloadAllData()

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
        let tables = Tables[selectedSegment]
        let table = tables![indexPath.row]
        cell.tableName.text = table.name
        if (table.orderedDate?.isEmpty)! {
            cell.tableImage.image = #imageLiteral(resourceName: "tableFree")
        } else {
            cell.tableImage.image = #imageLiteral(resourceName: "tableTaken")
        }
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: table.price! as NSNumber) {
            cell.tablePrice.text = formattedTipAmount
        }       

        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8 // optional
        
        
        return cell
    }
   @objc func updateCells() {
    
        let date = Date()
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var releaseDate = Date()

        let indexPathsArray = collectionView.indexPathsForVisibleItems
        for indexPath in indexPathsArray {
            let tables = Tables[selectedSegment]
            let cell = collectionView.cellForItem(at: indexPath) as! TableCollectionViewCell

            if (tables![indexPath.row].orderedDate?.isEmpty)! {
                cell.tableTimer.isHidden = true
                cell.tablePrice.isHidden = true
                
                continue
            }
            releaseDate = releaseDateFormatter.date(from: tables![indexPath.row].orderedDate!)!

            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
            let differenceOfDate = Calendar.current.dateComponents(components, from: releaseDate, to: date)

            let hours = differenceOfDate.hour
            let minutes = differenceOfDate.minute
            let seconds = differenceOfDate.second
            
            var newValue = ""
            if hours! > 0 {
                newValue = String(format: "%02d:%02d:%02d", hours!, minutes!, seconds!)
            } else {
                newValue = String(format: "%02d:%02d", minutes!, seconds!)
            }

            cell.tableTimer.isHidden = false
            cell.tablePrice.isHidden = false

            cell.tableTimer.text = newValue
        }
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

