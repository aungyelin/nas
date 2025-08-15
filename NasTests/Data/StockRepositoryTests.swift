
//
//  StockRepositoryTests.swift
//  NasTests
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import XCTest
import RxSwift
import RxTest
import FactoryKit
@testable import Nas

class StockRepositoryTests: XCTestCase {

    var stockRepository: StockRepository!
    var csvReader: MockCsvReader!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        csvReader = MockCsvReader()
        Container.shared.csvReader.register { self.csvReader }
        stockRepository = StockRepositoryImpl()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        stockRepository = nil
        csvReader = nil
        disposeBag = nil
        super.tearDown()
    }

    func test_getStocks_success() {
        // Arrange
        let stocksDto = [StockDto(name: "Apple", price: 150.0)]
        csvReader.result = .success(stocksDto)

        // Act
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Stock].self)

        stockRepository.getStocks()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        // Assert
        XCTAssertEqual(observer.events.count, 2)
        XCTAssertEqual(observer.events[0].value.element?.first?.name, "Apple")
        XCTAssertTrue(observer.events[1].value.isCompleted)
    }

    func test_getStocks_failure() {
        // Arrange
        let error = LocalError(message: "Test Error")
        csvReader.result = .failure(error)

        // Act
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([Stock].self)

        stockRepository.getStocks()
            .asObservable()
            .subscribe(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        // Assert
        XCTAssertEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events[0].value.error as? NasError, error.toDomain())
    }
    
}

class MockCsvReader: CsvReaderProtocol {
    
    var result: Result<[StockDto], Error> = .success([])

    func getStocks() -> Single<[StockDto]> {
        return Single.create { single in
            switch self.result {
            case .success(let dtos):
                single(.success(dtos))
            case .failure(let error):
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}
