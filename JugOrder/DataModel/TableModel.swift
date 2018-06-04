//
//  TableModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 28.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation

import UIKit

class TableModel: NSObject {
    
    var id : Int?
    var category : String?
    var name: String?
    var orderedDate: String?
    var price: Int?
    
    override init() {
        
    }

    
    static func downloadTables(completion: @escaping (_ result: [String: [TableModel]]) -> Void) {
        RestAPIManager.sharedInstance.getTables { (json) in
            var records = NSArray()
            records =  json["records"] as! NSArray
            
            var jsonElement = NSDictionary()
            var result = [String: [TableModel]]()
            
             for i in 0 ..< records.count
             {
                 jsonElement = records[i] as! NSDictionary
                
                 if let id = jsonElement["id"] as? String,
                 let tableName = jsonElement["name"] as? String,
                 let category = jsonElement["category"] as? String
                 {
                     let orderDate = jsonElement["orderDate"] as? String
                     let price = jsonElement["price"] as? String
                     let table = TableModel()
                     table.id = Int(id)
                     table.name = tableName
                     table.category = category
                    //get later from db -->change select
                    table.price = 0
                    if price != nil {
                        table.price = Int(price!)
                    }
                    table.orderedDate = ""
                    if orderDate != nil {
                        table.orderedDate = orderDate
                    }
                    
                     if (result[category] == nil) {
                         var arrayOfStrings = [TableModel]()
                         arrayOfStrings.append(table)
                        
                         result.updateValue(arrayOfStrings, forKey: category)
                     } else {
                         var tables = result[category]
                         tables?.append(table)
                         result.updateValue(tables!, forKey: category)
                     }
                 
                }
                
            }
            DispatchQueue.main.async(execute: { () -> Void in
                completion(result)
            })
        }

    }
    
    static func downloadTable(id: String, completion: @escaping (_ result: [ProductModel]) -> Void) {
        RestAPIManager.sharedInstance.getTable(id: id) { (json) in
            if let records = json["records"] as? NSArray {
                
                var jsonElement = NSDictionary()
                var result = [ProductModel]()
                
                for i in 0 ..< records.count
                {
                    jsonElement = records[i] as! NSDictionary
                    
                    if let id = jsonElement["id"] as? String,
                        let status = jsonElement["Status"] as? String,
                        let quantity = jsonElement["Quantity"] as? String,
                        let details = jsonElement["Details"] as? String

                    {
                        var Products = allProducts
                        
                        Products = Products.filter { $0.id == Int(id) }
                        let product = Products[0].copy() as! ProductModel
                        product.count = Int(quantity)
                        product.details = details
                        product.Status = Int(status)
                        result.append(product)
                        
                    }
                    
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(result)
                })
            }
        }
        
    }
}
