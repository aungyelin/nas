
//
//  ErrorMapperTests.swift
//  NasTests
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import XCTest
@testable import Nas

class ErrorMapperTests: XCTestCase {

    func test_mapNetworkError_to_NasError() {
        // Arrange
        let networkError = NetworkError(message: "Test Network Error")

        // Act
        let nasError = networkError.toDomain()

        // Assert
        XCTAssertEqual(nasError.type, .network)
        XCTAssertEqual(nasError.message, "Test Network Error")
    }

    func test_mapLocalError_to_NasError() {
        // Arrange
        let localError = LocalError(message: "Test Local Error")

        // Act
        let nasError = localError.toDomain()

        // Assert
        XCTAssertEqual(nasError.type, .csv)
        XCTAssertEqual(nasError.message, "Test Local Error")
    }
    
}
