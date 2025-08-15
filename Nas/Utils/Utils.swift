//
//  Utils.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import UIKit

func getMoneyFormat(value: Double) -> String? {

    let formatter = NumberFormatter()
    
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    formatter.currencySymbol = ""
    
    return formatter.string(from: NSNumber(value: value))
    
}
