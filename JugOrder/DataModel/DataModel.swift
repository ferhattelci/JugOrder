//
//  DataModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation

protocol HomeModelProtocol: class {
    func productsDownloaded(items: [String: [String:[ProductModel]]], allItems: [ProductModel])
}


class DataModel: NSObject, URLSessionDataDelegate{
    
    weak var delegate: HomeModelProtocol!

    func downloadProducts(){
        let urlPath = "http://qurnaz01.myftp.org/api/products/read.php" //this will be changed to the path where service.php lives
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
            
        }
        
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSDictionary()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        var result = [String: [String:[ProductModel]]]()
        var result2 = [ProductModel]()

        var jsonResults = NSArray()
        jsonResults =  jsonResult["records"] as! NSArray
        
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
                        result.updateValue(categoryExists, forKey: category)
                        //result.updateValue(subcategoryExists, forKey: category)
                    }
                    else {
                        //subcategory not exist
                        var products = [ProductModel]()
                        products.append(product)
                        categoryExists.updateValue(products, forKey: subcategory)
                        result.updateValue(categoryExists, forKey: category)
                        
                    }
                }
                else {
                    //category does not exist
                    var products = [ProductModel]()
                    products.append(product)
                    result.updateValue([subcategory : products], forKey: category)
                }
                

                result2.append(product)

            }
            result2.sort {
                $0.name! < $1.name!
            }
            
 
  
        }
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.productsDownloaded(items: result, allItems: result2)
            
        })
        
    }
}
