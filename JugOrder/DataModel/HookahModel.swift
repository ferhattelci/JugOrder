//
//  HookahModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 29.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation

class HookahModel : ProductModel {
    
    var tabak: [ProductModel] = []
    
   static func downloadHookahMix(){

        RestAPIManager.sharedInstance.getHookahMix { (json) in
            var jsonResults = NSArray()
            var result = [String: [String]]()
            var jsonElement = NSDictionary()
            
            jsonResults =  json["records"] as! NSArray

            for i in 0 ..< jsonResults.count
            {
                jsonElement = jsonResults[i] as! NSDictionary
                
                if let hookahID = jsonElement["id"] as? String,
                    let tobaccoid = jsonElement["tobaccoid"] as? String
                {
                    
                    if (result[hookahID] == nil) {
                        var arrayOfStrings = [String]()
                        arrayOfStrings.append(tobaccoid)
                        result.updateValue(arrayOfStrings, forKey: hookahID)
                    } else {
                        var tobaccoIDS = result[hookahID]
                        tobaccoIDS?.append(tobaccoid)
                        result.updateValue(tobaccoIDS!, forKey: hookahID)
                    }
                    
                    
                    
                }
                
                
            }
            DispatchQueue.main.async(execute: { () -> Void in
                setHookahToTabacco(Config: result)
                
            })
            
        }
      
    
    
    }
    
    static func setHookahToTabacco(Config: [String: [String]]){
        let hookahItems = Products["Hookah"]
        
        for i in 0 ..< hookahItems!.keys.count {
            let value = Array(hookahItems!)[i].value
            for j in 0 ..< value.count{
                let hookah = value[j] 
                let tobaccos = Config[String(hookah.id!)]
                var mix = ""
                for n in 0 ..< tobaccos!.count {
                    //hookah.tabak.append(contentsOf: Sequence)
                    let tobacco = tobaccos![n]
                    
                    let result = allProducts.compactMap {
                        $0.id == Int(tobacco) ? $0 : nil
                    }
                    mix = mix + result[0].name! + ", "
                    
                }
                
                mix = String(mix.dropLast())
                hookah.details = String(mix.dropLast())
        //        value[j] = hookah
            }
            
        }
        
        
    }
}

