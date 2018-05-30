//
//  ProductModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation
import UIKit

class ProductModel: NSObject, NSCopying {
    
    var id : Int?
    var amount: Int?
    var name : String?
    var details : String?

    var imagePath: String?
    var image: UIImage?
    var subCategory: String?
    var category: String?
    var price: Int?
    var count: Int?
    
    override init() {
        
    }
    
    init(id: Int, amount: Int, name: String, imagePath: String, subCategory: String, category:String, price:Int, count:Int, details:String, image: UIImage) {
        self.id = id
        self.name = name
        self.imagePath = imagePath
        self.subCategory = subCategory
        self.category = category
        self.price = price
        self.amount = amount
        self.count = count
        self.details = details
        self.image = image
        
    }
    func checkForOrder(_ otherProduct: ProductModel, _ order: ComparisonResult) -> Bool {
        if let createdName = self.name, let othersName = otherProduct.name {
            //This line will compare both date with the order that has been passed.
            return createdName.compare(othersName) == order
        }
        return false
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ProductModel(id: id!, amount: amount!, name: name!, imagePath: imagePath!, subCategory: subCategory!, category: category!, price: price!, count: count!, details: details!, image:image!)
        return copy
    }
    
    func getImageFromURL(){
        
        let url_string = "http://qurnaz01.myftp.org/images/" + category! + "/" +  subCategory! + "/" + imagePath!
        if let encoded = url_string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded)
        {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
        
   
    }
    
 
}
