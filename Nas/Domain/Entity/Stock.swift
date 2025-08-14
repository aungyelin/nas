//
//  Stock.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import Differentiator

struct Stock: IdentifiableType, Equatable {
    var name: String
    var price: Double
    
    var identity: String {
        return UUID().uuidString
    }
}
