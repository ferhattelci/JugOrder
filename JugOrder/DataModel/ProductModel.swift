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
    var Status: Int?
    
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
    static func downloadProducts() {
        
        RestAPIManager.sharedInstance.getProducts { (json) in
            var jsonElement = NSDictionary()
            var result = [String: [String:[ProductModel]]]()
            var result2 = [ProductModel]()
            
            var jsonResults = NSArray()
            jsonResults =  json["records"] as! NSArray
            
            for i in 0 ..< jsonResults.count
            {
                
                jsonElement = jsonResults[i] as! NSDictionary
                let product = ProductModel()
                
                //the following insures none of the JsonElement values are nil through optional binding
                if let name = jsonElement["name"] as? String,
                    let id = jsonElement["id"] as? String,
                    let amount = jsonElement["amount"] as? String,
                    let imagePath = jsonElement["imagePath"] as? String,
                    let category = jsonElement["CategoryName"] as? String,
                    let subcategory = jsonElement["subcategory_name"] as? String,
                    let price = jsonElement["price"] as? String
                {
                    product.id = Int(id)!
                    product.amount = Int(amount)!
                    product.name = name
                    product.imagePath = imagePath
                    product.category = category
                    product.subCategory = subcategory
                    product.price = Int(price)
                    product.details = ""
                    product.image = #imageLiteral(resourceName: "26289119_digital-image") // standard image
                    
                    //Standard value
                    product.count = 0
                    
                    if product.imagePath != nil || !imagePath.isEmpty{
                        product.getImageFromURL()
                    }
                    
                    
                    if var categoryExists = result[category]{
                        //category exist
                        if var subcategoryExists = categoryExists[subcategory]{
                            //subcategory exist
                       
                            subcategoryExists.append(product)
                            
                            categoryExists.updateValue(subcategoryExists, forKey: subcategory)
                            //  result.updateValue(categoryExists, forKey: category)
                            //result.updateValue(subcategoryExists, forKey: category)
                        }
                        else {
                            //subcategory not exist
                            var products = [ProductModel]()
           
                            products.append(product)
                            
                            categoryExists.updateValue(products, forKey: subcategory)
                            
                        }
                        
                        result.updateValue(categoryExists, forKey: category)
                        
                    }
                    else {
                        //category does not exist
                        var products = [ProductModel]()
                  
                        products.append(product)
                        
                        // products.append(product)
                        result.updateValue([subcategory : products], forKey: category)
                    }
                    
      
                    result2.append(product)
                    
                    
                }
                result2.sort {
                    $0.name! < $1.name!
                }
                
                
                
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                Products = result
                allProducts = result2
                HookahModel.downloadHookahMix()
                
            })
            
        }

        
    }
    
   
    
 
}
