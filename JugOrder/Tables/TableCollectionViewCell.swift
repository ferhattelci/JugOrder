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
  
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                super.isSelected = true
                self.contentView.backgroundColor = .jugBlue
                self.contentView.tintColor = .jugWhite
                
            }
            else
            {
                super.isSelected = false
                self.contentView.backgroundColor = .jugWhite
                self.contentView.tintColor = UIColor.black
                
            }
        }
    }
    
}
