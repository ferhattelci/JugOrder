//
//  ProductModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation

class ProductModel: NSObject {
    
    var id : Int?
    var amount: Int?
    var name : String?
    var imagePath: String?
    var subCategory: String?
    var category: String?
    var price: Int?
    
    
    override init() {
        
    }
    
    init(id: Int, amount: Int, name: String, imagePath: String, subCategory: String, category:String, price:Int) {
        
        self.id = id
        self.name = name
        self.imagePath = imagePath
        self.subCategory = subCategory
        self.category = category
        self.price = price
        self.amount = amount
        
    }
    func checkForOrder(_ otherProduct: ProductModel, _ order: ComparisonResult) -> Bool {
    if let createdName = self.name, let othersName = otherProduct.name {
        //This line will compare both date with the order that has been passed.
        return createdName.compare(othersName) == order
    }
    return false
}
    
}
