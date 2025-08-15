
//
//  MainVMTests.swift
//  NasTests
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
import FactoryKit
@testable import Nas

class MainVMTests: XCTestCase {
    
    var mainVM: MainVM!
    var getNewsUseCase: MockGetNewsUseCase!
    var getStockUseCase: MockGetStockUseCase!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        getNewsUseCase = MockGetNewsUseCase()
        getStockUseCase = MockGetStockUseCase()
        Container.shared.getNewsUseCase.register { self.getNewsUseCase }
        Container.shared.getStockUseCase.register { self.getStockUseCase }
        mainVM = MainVM()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        mainVM = nil
        getNewsUseCase = nil
        getStockUseCase = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func test_fetchAllData_success() {
        // Arrange
        let articles = [Article(source: nil, author: nil, title: "Test Title", description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil)]
        let stocks = [Stock(name: "Apple", price: 150.0)]
        getNewsUseCase.result = .success(articles)
        getStockUseCase.result = .success(stocks)
        
        let stocksObserver = scheduler.createObserver([Stock]?.self)
        let newsObserver = scheduler.createObserver([Article]?.self)
        let sectionsObserver = scheduler.createObserver([MainSection].self)
        
        mainVM.stocksDriver.drive(stocksObserver).disposed(by: disposeBag)
        mainVM.newsDriver.drive(newsObserver).disposed(by: disposeBag)
        mainVM.sectionDriver.drive(sectionsObserver).disposed(by: disposeBag)
        
        // Act
        mainVM.fetchAllData()
        scheduler.start()
        
        // Assert
        XCTAssertEqual(stocksObserver.events.last?.value.element??.count, 1)
        XCTAssertEqual(newsObserver.events.last?.value.element??.count, 1)
        XCTAssertEqual(sectionsObserver.events.last?.value.element?.count, 2)
    }
    
    func test_fetchAllData_failure() {
        // Arrange
        let error = NasError(type: .network, message: "Test Error")
        getNewsUseCase.result = .failure(error)
        getStockUseCase.result = .failure(error)
        
        let errorObserver = scheduler.createObserver(NasError.self)
        mainVM.errorDriver.drive(errorObserver).disposed(by: disposeBag)
        
        // Act
        mainVM.fetchAllData()
        scheduler.start()
        
        // Assert
        XCTAssertEqual(errorObserver.events.count, 1)
        XCTAssertEqual(errorObserver.events[0].value.element, error)
    }
    
}

class MockGetNewsUseCase: GetNewsUseCase {
    
    var result: Result<[Article], Error> = .success([])
    
    func execute() -> Single<[Article]> {
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

class MockGetStockUseCase: GetStockUseCase {
    
    var result: Result<[Stock], Error> = .success([])
    
    func execute() -> Single<[Stock]> {
        return Single.create { single in
            switch self.result {
            case .success(let stocks):
                single(.success(stocks))
            case .failure(let error):
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}
