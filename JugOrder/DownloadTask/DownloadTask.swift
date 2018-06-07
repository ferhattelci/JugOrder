//
//  DownloadTask.swift
//  JugOrder
//
//  Created by Ferhat Telci on 07.06.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import UIKit
protocol DownloadTask {
    
    var completionHandler: ResultType<Data>.Completion? { get set }
    var progressHandler: ((Double) -> Void)? { get set }
    
    func resume()
    func suspend()
    func cancel()
}
