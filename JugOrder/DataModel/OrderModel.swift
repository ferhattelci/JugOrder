//
//  OrderModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 03.06.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation
import UIKit

class OrderModel: NSObject {
    
    var id : Int?
    var TableID : Int?
    var Paid: Int?
    var orderedDate: String?
    var EmployeeID : Int?
    
    override init() {
        
    }
    
    static func readOrder(table: String, completion: @escaping (_ result: OrderModel) -> Void) {

        let order = OrderModel()

        RestAPIManager.sharedInstance.getOrder(id: table) { (json) in
            if let records = json["records"] as? NSArray {
                var jsonElement = NSDictionary()
                jsonElement = records[0] as! NSDictionary
                if let id = jsonElement["id"] as? String,
                    let tableid = jsonElement["TableID"] as? String,
                    let employeeID = jsonElement["EmployeeID"] as? String,
                    let Paid = jsonElement["Paid"] as? String,
                    let orderDate = jsonElement["OrderDate"] as? String

                {
                    order.id = Int(id)
                    order.EmployeeID = Int(employeeID)
                    order.Paid = Int(Paid)
                    order.TableID = Int(tableid)
                    order.orderedDate = orderDate
        
                    
                }
                completion(order)
            }
        }
        
    }
    
    static func createOrder(table: String, employee: String, pproducts: [ProductModel]) {

        let body = "TableID="+table+"&EmployeeID="+employee+"&Paid=0"

        RestAPIManager.sharedInstance.createOrder(body: body) { (json) in
            if let records = json["records"] as? NSArray {
                var jsonElement = NSDictionary()
                jsonElement = records[0] as! NSDictionary
                if let id = jsonElement["id"] as? String {
                    createOrderItems(pOrderID: id, pProducts: pproducts)
                }
            }
        }
    }
    static func createOrderItems(pOrderID: String, pProducts: [ProductModel]) {
        
        var body = "OrderID="+pOrderID
        for product in pProducts {
            body = body + "&ProductID="+String(product.id!)+"&Details="+product.details!+"&Price="+String(product.price!)+"&Quantity="+String(product.count!)

            RestAPIManager.sharedInstance.createOrderItems(body: body) { (json) in
        
            }
            
            
        }
  
    }
        
        
}
    
