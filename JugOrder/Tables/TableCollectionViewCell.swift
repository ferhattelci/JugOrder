//
//  TableCollectionViewCell.swift
//  JugOrder
//
//  Created by Ferhat Telci on 30.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class TableCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tableName: UILabel!
    @IBOutlet weak var tablePrice: UILabel!
    @IBOutlet weak var tableTimer: UILabel!
    @IBOutlet weak var tableImage: UIImageView!
    
    var timer = Timer()
    var releaseDate = Date()
    
    func updateRow(preleaseDate: String ){
        print("started timer")
  
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TableCollectionViewCell.decreaseTimer), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(TableViewController.updateCells),
                                     userInfo: nil, repeats: true)
    }
    
}
