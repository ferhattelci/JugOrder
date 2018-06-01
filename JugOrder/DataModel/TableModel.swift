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
        RestAPIManager.sharedInstance.getTable { (json) in
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
                     let table = TableModel()
                     table.id = Int(id)
                     table.name = tableName
                     table.category = category
                    //get later from db -->change select
                     table.price = 10
                     table.orderedDate = "2018-06-01 02:19:30"
                    
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
}
