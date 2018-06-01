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
    
    let baseURL = "http://qurnaz01.myftp.org/api/"
    
    func getTable(onCompletion: @escaping (NSDictionary) -> Void) {
        let route = baseURL + "table/load.php"

        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    
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
    
    func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
        guard let url = URL(string: baseURL + path) else { return}
        var request = URLRequest.init(url: url)
        
        // Set the method to POST
        request.httpMethod = "POST"
        // Set the POST body for the request
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

        } catch let error {
            print(error.localizedDescription)
        }

        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    onCompletion(json, error!)
                    
                } catch let error  {
                    print(error.localizedDescription)
                }
            }
            
            
        }
        task.resume()
    }
}
