//
//  ResultType.swift
//  JugOrder
//
//  Created by Ferhat Telci on 07.06.18.
//  Copyright © 2018 Ferhat Telci. All rights reserved.
//

import Foundation
public enum ResultType<T> {
    
    public typealias Completion = (ResultType<T>) -> Void
    
    case success(T)
    case failure(Swift.Error)
    
}
