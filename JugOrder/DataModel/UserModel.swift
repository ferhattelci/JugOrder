//
//  UserModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 06.06.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation

class UserModel: NSObject {
    
    var id : Int!
    var name : String!
    var surname : String!
    var username: String!
    var password: String!
    
    init(id: Int, name: String, surname: String, username: String!, password: String!) {
        self.id = id
        self.username = username
        self.name = name
        self.surname = surname
        self.password = password
    }
    
    override init() {
        
    }
    func getData(completion: @escaping (_ result: UserModel) -> Void) {
        RestAPIManager.sharedInstance.getUser(user: self) { (json) in
            if let records = json["records"] as? NSArray {
                var jsonElement = NSDictionary()
                jsonElement = records[0] as! NSDictionary
                if let id = jsonElement["id"] as? String,
                    let firstname = jsonElement["FirstName"] as? String,
                    let lastname = jsonElement["LastName"] as? String
                    
                {
                    self.id = Int(id)
                    self.name = firstname
                    self.surname = lastname
                    
                }
                
                completion(self)
            }
        }
    }
    
}
