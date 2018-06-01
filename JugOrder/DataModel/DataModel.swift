//
//  DataModel.swift
//  JugOrder
//
//  Created by Ferhat Telci on 27.05.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation

protocol HomeModelProtocol: class {
    func downloadedAllData()
}

class DataModel: NSObject, URLSessionDataDelegate{
    static let sharedInstance = DataModel()
    weak var delegate: HomeModelProtocol!

    
    func downloadAllData(){
        TableModel.downloadTables { (result) in
            Tables = result
            self.delegate.downloadedAllData()

        }

        
    }

 
}
