//
//  CategoryModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 28.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation

import UIKit

class CategoryModel: NSObject {
    
    var name : String?
    var imagePath: String?
    var image: UIImage?
    
    
    override init() {
 
    }
    
    func getImageFromURL(category: String){
        var imageName = String((imagePath?.dropLast())!)
        imageName = String(String(imageName.dropLast()).dropLast())
        imageName = String(imageName.dropLast())

        self.image = UIImage(named: imageName)
      
    }
    

    
}
