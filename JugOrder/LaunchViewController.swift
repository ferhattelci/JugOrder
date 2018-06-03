//
//  LaunchViewController.swift
//  JugOrder
//
//  Created by Ferhat Telci on 29.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//
import UserNotifications
import UIKit

class LaunchViewController: UIViewController, HomeModelProtocol {
    
    @IBOutlet weak var progressWheel: UIActivityIndicatorView!
    func downloadedAllData() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TableNavigationController") as! UINavigationController
        
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeModel = DataModel()
        homeModel.delegate = self
        homeModel.downloadAllData()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if error != nil {
                print("unsuccess Auto")
            } else {
                print("success Auto")
            }
        }

        
        ProductModel.downloadProducts()

        
    }

    func productsDownloaded(items: [String : [String : [ProductModel]]], allItems: [ProductModel]) {
        Products = items
        allProducts = allItems
        
      
    }

    






}
