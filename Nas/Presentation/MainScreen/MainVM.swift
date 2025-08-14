//
//  MainVM.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift
import RxCocoa
import FactoryKit

class MainVM: NSObject, HasDisposeBag {
    
    static let shared = MainVM()
    
    @Injected(\.getNewsUseCase) private var getNewsUseCase
    @Injected(\.getStockUseCase) private var getStockUseCase
    
    private let refreshingRelay = BehaviorRelay<Bool>(value: false)
    var refreshingDriver: Driver<Bool> { return refreshingRelay.asDriver() }
    
    private let errorRelay = PublishRelay<NasError>()
    var errorDriver: Driver<NasError> { return errorRelay.asDriver(onErrorDriveWith: .empty()) }
    
    
    func fetchAllData() {
        Completable.zip([
            self.fetchStocks(),
            self.fetchNews()
        ])
        .attach(refreshingRelay)
        .do(onError: { [weak self] e in
            if let error = e as? NasError {
                self?.errorRelay.accept(error)
            } else {
                self?.errorRelay.accept(NasError(type: .unknown, message: e.localizedDescription))
            }
        }, onCompleted: {
            self.getStockDataChanges()
        })
        .subscribe()
        .disposed(by: disposeBag)
    }
    
    func getStockDataChanges() {
        Observable<Int>.interval(.milliseconds(1000), scheduler: MainScheduler.instance)
            .flatMap { [weak self] _ -> Completable in
                guard let self = self else { return .empty() }
                return self.fetchStocks()
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func fetchNews() -> Completable {
        return getNewsUseCase.execute()
            .do(onSuccess: { articles in
                print("fetchNews: success")
            })
            .asCompletable()
    }
    
    func fetchStocks() -> Completable {
        return getStockUseCase.execute()
            .do(onSuccess: { stocks in
                print("fetchStocks: success with \(stocks.count) stocks")
                for stock in stocks {
                    print("\(stock.name) -> \(stock.price)")
                }
                print("-----------------------------")
            })
            .asCompletable()
    }
    
}
