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
    var start: String!
    var end: String!
    var trackID: Int!


    
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
    
    func getStartWork(completion: @escaping (_ result: UserModel) -> Void){
        RestAPIManager.sharedInstance.getTracker(user: self) { (json) in
            if let records = json["records"] as? NSArray {
                var jsonElement = NSDictionary()
                jsonElement = records[0] as! NSDictionary
                if let id = jsonElement["id"] as? String,
                    let start = jsonElement["Start"] as? String,
                    let end = jsonElement["End"] as? String
                    
                {
                    self.trackID = Int(id)
                    self.start = start
                    self.end = end
                    
                }
                completion(self)
                
            }
        }
    }
    func createStartWork(){
        getStartWork { (user) in
            if user.trackID == nil {
                let body = "EmployeeID="+String(self.id!)
                RestAPIManager.sharedInstance.createStartWork(body: body, onCompletion: { (json) in
                    if let records = json["records"] as? NSArray {
                        var jsonElement = NSDictionary()
                        jsonElement = records[0] as! NSDictionary
                        if let id = jsonElement["id"] as? String
                            
                        {
                            self.trackID = Int(id)
                        }
                    }
                })
            
            }
            
        }
       
    }
    
    func createEndWork(){
        if self.trackID != nil {
            let body = "id="+String(self.trackID!)
            RestAPIManager.sharedInstance.createEndWork(body: body)
            
        }
    }
    
    
}
