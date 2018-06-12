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
    
    func readOrder( completion: @escaping (_ result: OrderModel) -> Void) {


        RestAPIManager.sharedInstance.getOrder(id: String(TableID!)) { (json) in
            if let records = json["records"] as? NSArray {
                var jsonElement = NSDictionary()
                jsonElement = records[0] as! NSDictionary
                if let id = jsonElement["id"] as? String,
                    let tableid = jsonElement["TableID"] as? String,
                    let employeeID = jsonElement["EmployeeID"] as? String,
                    let Paid = jsonElement["Paid"] as? String,
                    let orderDate = jsonElement["OrderDate"] as? String

                {
                    self.id = Int(id)
                    self.EmployeeID = Int(employeeID)
                    self.Paid = Int(Paid)
                    self.TableID = Int(tableid)
                    self.orderedDate = orderDate
        
                    
                }
                completion(self)
            }
        }
        
    }
    
    func createOrder(pproducts: [ProductModel]) {
        let body = "TableID="+String(TableID!)+"&EmployeeID="+String(EmployeeID!)+"&Paid=0"
        
        RestAPIManager.sharedInstance.createOrder(body: body) { (json) in
            if let records = json["records"] as? NSArray {
                var jsonElement = NSDictionary()
                jsonElement = records[0] as! NSDictionary
                if let id = jsonElement["id"] as? String {
                    self.id = Int(id)
                    self.createOrderItems(pProducts: pproducts)
                }
            }
        }
    }
    func createOrderItems(pProducts: [ProductModel]) {
        
        var body = "OrderID="+String(self.id!)
        for product in pProducts {
            body = body + "&ProductID="+String(product.id!)+"&Details="+product.details!+"&Price="+String(product.price!)+"&Quantity="+String(product.count!)
            RestAPIManager.sharedInstance.createOrderItems(body: body)
        }
  
    }
    
    func transferOrder(newTableID: String){
        let body = "id=" + String(id!) + "&TableID=" + newTableID
        RestAPIManager.sharedInstance.transferOrder(body: body)
        
    }
        
        
}
    
