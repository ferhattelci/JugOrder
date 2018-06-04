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
    
    func createHookah() {
        
        let body = "name="+self.name!+"&price="+String(self.price!)+"&imagePath="+String(self.imagePath!)+"&amount="+String(self.amount!)+"&category_id=3&subcategory_id=20"
        //+String(self.subCategory!)
        
        RestAPIManager.sharedInstance.createHookah(body: body) { (json) in
            if let records = json["records"] as? NSArray {
                var jsonElement = NSDictionary()
                jsonElement = records[0] as! NSDictionary
                if let id = jsonElement["id"] as? String {
                    self.id = Int(id)
                    self.appendTabacco()
                }
            }
        }
    }
    
    func appendTabacco() {
        var body = "HookahID="+String(self.id!)
        for tabacco in self.tabak {
            body = body + "&TobaccoID="+String(tabacco.id!)
            RestAPIManager.sharedInstance.appendTabacoo(body: body) { (json) in
                
            }
            
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
            }
            
        }
        
        
    }
}

