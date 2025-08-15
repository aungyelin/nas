
//
//  GetNewsUseCaseTests.swift
//  NasTests
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import XCTest
import RxSwift
import RxTest
import FactoryKit
@testable import Nas

class GetNewsUseCaseTests: XCTestCase {
    
    var getNewsUseCase: GetNewsUseCase!
    var newsRepository: MockNewsRepository!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        newsRepository = MockNewsRepository()
        Container.shared.newsRepository.register { self.newsRepository }
        getNewsUseCase = GetNewsUseCaseImpl()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        getNewsUseCase = nil
        newsRepository = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func test_getNews_success() {
        // Arrange
        let articles = [Article(source: nil, author: nil, title: "Test Title", description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil)]
        newsRepository.result = .success(articles)
        
        // Act
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Article].self)
        
        getNewsUseCase.execute()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Assert
        XCTAssertEqual(observer.events.count, 2)
        XCTAssertEqual(observer.events[0].value.element, articles)
        XCTAssertTrue(observer.events[1].value.isCompleted)
    }
    
    func test_getNews_failure() {
        // Arrange
        let error = NasError(type: .network, message: "Test Error")
        newsRepository.result = .failure(error)
        
        // Act
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Article].self)
        
        getNewsUseCase.execute()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Assert
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.error as? NasError, error)
    }
    
}

class MockNewsRepository: NewsRepository {
    
    var result: Result<[Article], Error> = .success([])
    
    func getNews() -> Single<[Article]> {
        return Single.create { single in
            switch self.result {
            case .success(let articles):
                single(.success(articles))
            case .failure(let error):
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}
