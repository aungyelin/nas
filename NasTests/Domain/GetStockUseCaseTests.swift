
//
//  GetStockUseCaseTests.swift
//  NasTests
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import XCTest
import RxSwift
import RxTest
import FactoryKit
@testable import Nas

class GetStockUseCaseTests: XCTestCase {
    
    var getStockUseCase: GetStockUseCase!
    var stockRepository: MockStockRepository!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        stockRepository = MockStockRepository()
        Container.shared.stockRepository.register { self.stockRepository }
        getStockUseCase = GetStockUseCaseImpl()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        getStockUseCase = nil
        stockRepository = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func test_getStocks_success() {
        // Arrange
        let stocks = [Stock(name: "Apple", price: 150.0)]
        stockRepository.result = .success(stocks)
        
        // Act
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Stock].self)
        
        getStockUseCase.execute()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Assert
        XCTAssertEqual(observer.events.count, 2)
        XCTAssertEqual(observer.events[0].value.element, stocks)
        XCTAssertTrue(observer.events[1].value.isCompleted)
    }
    
    func test_getStocks_failure() {
        // Arrange
        let error = NasError(type: .csv, message: "Test Error")
        stockRepository.result = .failure(error)
        
        // Act
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Stock].self)
        
        getStockUseCase.execute()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Assert
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.error as? NasError, error)
    }
    
}

class MockStockRepository: StockRepository {
    
    var result: Result<[Stock], Error> = .success([])
    
    func getStocks() -> Single<[Stock]> {
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
