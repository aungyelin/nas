//
//  Double.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation

extension String {
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
}
