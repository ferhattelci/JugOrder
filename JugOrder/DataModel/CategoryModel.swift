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
        let imageURL = "http://192.168.23.178/images/" + category + "/" + imagePath!
        
        DispatchQueue.main.async(execute: { () -> Void in
            do {
                let imageData: Data = try Data(contentsOf: URL(string: imageURL)!)
                self.image = UIImage(data: imageData)!
            }
            catch let error {
                //print(error)
            }
        })
      
    }
    
}
