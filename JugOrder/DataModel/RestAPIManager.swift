//
//  RestAPIManager.swift
//  JugOrder
//
//  Created by Ferhat Telci on 31.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation
typealias ServiceResponse = (NSDictionary, Error?) -> Void

import UIKit
class RestAPIManager: NSObject {
    static let sharedInstance = RestAPIManager()
    
    let baseURL = "http://192.168.23.178/api/"
    
    //User
    func getUser(user: UserModel, onCompletion: @escaping (NSDictionary) -> Void){
        let route = baseURL + "user/read.php?name=" + user.username + "&password=" + user.password
        
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    //Mark Hookah
    func createHookah(body: String, onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "products/createShisha.php"
        
        makeHTTPPostRequest(path: route, body: body) { (json, err) in
            onCompletion(json as NSDictionary)
        }
    }
    
    func appendTabacoo(body: String, onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "products/appendTobacco.php"
        
        makeHTTPPostRequest(path: route, body: body) { (json, err) in
            onCompletion(json as NSDictionary)
        }
    }
    
    func createSubCategory(body: String, onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "order/createShisha.php"
        
        makeHTTPPostRequest(path: route, body: body) { (json, err) in
            onCompletion(json as NSDictionary)
        }
    }
    
    //Mark Orders
    func getOrder(id: String, onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "order/read.php?id=" + id
        
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    func createOrder(body: String, onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "order/create.php"
       
        makeHTTPPostRequest(path: route, body: body) { (json, err) in
            onCompletion(json as NSDictionary)
        }
    }
    
    func createOrderItems(body:String, onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "order/createOrderItems.php"
        makeHTTPPostRequest(path: route, body: body) { (json, err) in
            onCompletion(json as NSDictionary)
        }
    }
    
    //MARK Tables
    func getTables(onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "table/load.php"

        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    func getTable(id: String, onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "table/read.php?id=" + id
        
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    //Mark Products
    func getProducts(onCompletion: @escaping (NSDictionary) -> Void){
        let route = baseURL + "products/read.php"
        
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    
    func getHookahMix(onCompletion: @escaping (NSDictionary) -> Void){
        let route = baseURL + "products/readTobacco.php"

            makeHTTPGetRequest(path: route, onCompletion: { (json, err) in
                onCompletion(json as NSDictionary)
            })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        guard let url = URL(string: path) else { return}
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    onCompletion(json, error)

                } catch let error  {
                    print(error.localizedDescription)
                }
            }

            
        }
        
        task.resume()
    }
    
    func makeHTTPPostRequest(path: String, body: String, onCompletion: @escaping ServiceResponse) {
        guard let url = URL(string: path) else { return}
        var request = URLRequest.init(url: url)

        // Set the method to POST
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")

        // Set the POST body for the request
        request.httpBody = body.data(using: String.Encoding.utf8);
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
         
            if let response = response {
                // print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    onCompletion(json, error)
                    
                } catch let error  {
                    print(error.localizedDescription)
                }
            }
            
            
        }
        task.resume()
    }
    
   

}
