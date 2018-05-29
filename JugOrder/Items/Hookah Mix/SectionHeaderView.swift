//
//  SectionHeaderView.swift
//  JugOrder
//
//  Created by Ferhat Telci on 29.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation
import  UIKit

class SectionHeaderView: UICollectionReusableView
{
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    var categoryTitle: String! {
        didSet {
            categoryTitleLabel.text = categoryTitle
        }
    }
}
