//
//  ItemCollectionViewCell.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productDetail: UILabel!
    @IBOutlet weak var stepperAmount: UIStepper!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productAmount: UILabel!
}
