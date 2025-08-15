
//
//  ArticleMapperTests.swift
//  NasTests
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import XCTest
@testable import Nas

class ArticleMapperTests: XCTestCase {

    func test_mapArticleDto_to_Article() {
        // Arrange
        let sourceDto = SourceDto(id: "1", name: "Test Source")
        let articleDto = ArticleDto(
            source: sourceDto,
            author: "Test Author",
            title: "Test Title",
            description: "Test Description",
            url: "https://test.com",
            urlToImage: "https://test.com/image.jpg",
            publishedAt: "2025-08-15T12:00:00Z",
            content: "Test Content"
        )

        // Act
        let article = articleDto.toDomain()

        // Assert
        XCTAssertEqual(article.source?.id, "1")
        XCTAssertEqual(article.source?.name, "Test Source")
        XCTAssertEqual(article.author, "Test Author")
        XCTAssertEqual(article.title, "Test Title")
        XCTAssertEqual(article.description, "Test Description")
        XCTAssertEqual(article.url, "https://test.com")
        XCTAssertEqual(article.urlToImage, "https://test.com/image.jpg")
        XCTAssertEqual(article.publishedAt, "2025-08-15T12:00:00Z")
        XCTAssertEqual(article.content, "Test Content")
    }
    
    func test_mapSourceDto_to_Source() {
        // Arrange
        let sourceDto = SourceDto(id: "1", name: "Test Source")
        
        // Act
        let source = sourceDto.toDomain()
        
        // Assert
        XCTAssertEqual(source.id, "1")
        XCTAssertEqual(source.name, "Test Source")
    }
    
}
