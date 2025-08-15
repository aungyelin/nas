
//
//  NewsRepositoryTests.swift
//  NasTests
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import XCTest
import RxSwift
import RxTest
import FactoryKit
@testable import Nas

class NewsRepositoryTests: XCTestCase {
    
    var newsRepository: NewsRepository!
    var apiService: MockApiService!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        apiService = MockApiService()
        Container.shared.apiService.register { self.apiService }
        newsRepository = NewsRepositoryImpl()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        newsRepository = nil
        apiService = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func test_getNews_success() {
        // Arrange
        let articlesDto = [ArticleDto(source: nil, author: nil, title: "Test Title", description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil)]
        let response = NewsResponse(status: "ok", totalResults: 1, articles: articlesDto)
        apiService.result = .success(response)
        
        // Act
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Article].self)
        
        newsRepository.getNews()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Assert
        XCTAssertEqual(observer.events.count, 2)
        XCTAssertEqual(observer.events[0].value.element?.first?.title, "Test Title")
        XCTAssertTrue(observer.events[1].value.isCompleted)
    }
    
    func test_getNews_failure() {
        // Arrange
        let error = NetworkError(message: "Test Error")
        apiService.result = .failure(error)
        
        // Act
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Article].self)
        
        newsRepository.getNews()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Assert
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.error as? NasError, error.toDomain())
    }
    
}

class MockApiService: ApiServiceProtocol {
    
    var result: Result<NewsResponse, Error> = .success(NewsResponse(status: "ok", totalResults: 0, articles: []))
    
    func getNews() -> Single<NewsResponse> {
        return Single.create { single in
            switch self.result {
            case .success(let response):
                single(.success(response))
            case .failure(let error):
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}
