//
//  StockMapper.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation

extension StockDto: DomainMappable {
    
    typealias T = Stock
    
    func toDomain() -> Stock {
        return Stock(
            name: self.name,
            price: self.price
        )
    }
    
}

