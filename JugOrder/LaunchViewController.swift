//
//  LaunchViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 29.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, HomeModelProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeModel = DataModel()
        homeModel.downloadProducts()
        homeModel.downloadTables()
        homeModel.downloadTobaccoMix()
        homeModel.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func productsDownloaded(items: [String : [String : [ProductModel]]], allItems: [ProductModel]) {
        Products = items
        allProducts = allItems
        
        setHookahToTabacco()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TableNavigationController") as! UINavigationController
        //let nav = UINavigationController(rootViewController: TableNavigationController)

        UIApplication.shared.keyWindow?.rootViewController = viewController
        
    }
    
    func configDownloaded(config: [String : [String]]) {
        Config = config
    }
    func tableDownloaded(config: [String : [TableModel]]) {
        Tables = config
    }

    func setHookahToTabacco(){
        let hookahItems = Products["Hookah"]
        
        for i in 0 ..< hookahItems!.keys.count {
            let value = Array(hookahItems!)[i].value
            for j in 0 ..< value.count{
                let hookah = value[j] as! HookahModel
                let tobaccos = Config[String(hookah.id!)]
                
                for n in 0 ..< tobaccos!.count {
                    //hookah.tabak.append(contentsOf: Sequence)
                    let tobacco = tobaccos![n]
                    
                    let result = allProducts.compactMap {
                        $0.id == Int(tobacco) ? $0 : nil
                    }
                    
                    hookah.tabak.append(result[0])
                    
                }

                
            }
            
        }

        
    }



}
