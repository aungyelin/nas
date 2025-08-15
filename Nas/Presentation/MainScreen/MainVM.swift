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
    
    private let stocksRelay = BehaviorRelay<[Stock]?>(value: nil)
    var stocksDriver: Driver<[Stock]?> { return stocksRelay.asDriver() }
    
    private let newsRelay = BehaviorRelay<[Article]?>(value: nil)
    var newsDriver: Driver<[Article]?> { return newsRelay.asDriver() }
    
    
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
    
    func fetchStocks() -> Completable {
        return getStockUseCase.execute()
            .do(onSuccess: { stocks in
                self.stocksRelay.accept(stocks)
            })
            .asCompletable()
    }
    
    func fetchNews() -> Completable {
        return getNewsUseCase.execute()
            .do(onSuccess: { articles in
                self.newsRelay.accept(articles)
            })
            .asCompletable()
    }
    
    var sectionDriver: Driver<[MainSection]> {
        
        return Driver<[MainSection]>.combineLatest(stocksDriver, newsDriver) { stocks, news in
            
            var sections: [MainSection] = []
            
            if let data = stocks {
                let stockItems = data.map { MainSectionItem.stock(stock: $0, viewModel: MainVM.shared) }
                
                if !stockItems.isEmpty {
                    sections.append(.stocks(items: stockItems))
                }
            }
            if let data = news {
                let highlightedNewsItems = data.prefix(6).map { MainSectionItem.news(article: $0) }
                let remainingNewsItems = data.dropFirst(6).map { MainSectionItem.news(article: $0) }
                
                if !highlightedNewsItems.isEmpty {
                    sections.append(.highlightedNews(items: highlightedNewsItems))
                }
                if !remainingNewsItems.isEmpty {
                    sections.append(.news(items: remainingNewsItems))
                }
            }
            
            return sections
            
        }
        
    }
    
}
