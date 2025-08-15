
//
//  StockMapperTests.swift
//  NasTests
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import XCTest
@testable import Nas

class StockMapperTests: XCTestCase {

    func test_mapStockDto_to_Stock() {
        // Arrange
        let stockDto = StockDto(name: "Apple", price: 150.0)

        // Act
        let stock = stockDto.toDomain()

        // Assert
        XCTAssertEqual(stock.name, "Apple")
        XCTAssertEqual(stock.price, 150.0)
    }
    
}
