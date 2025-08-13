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
    
    private let refreshingRelay = BehaviorRelay<Bool>(value: false)
    var refreshingDriver: Driver<Bool> { return refreshingRelay.asDriver() }
    
    
    func fetchAllData() {
        Completable.zip([
            self.fetchNews()
        ])
        .asDriver(onErrorDriveWith: .empty())
        .attach(refreshingRelay)
        .drive()
        .disposed(by: disposeBag)
    }
    
    func fetchNews() -> Completable {
        return getNewsUseCase.execute()
            .do(onSuccess: { articles in
                print("fetchNews: success")
            }, onError: { e in
                print("fetchNews: failed with error - \(e.localizedDescription)")
            })
            .asCompletable()
    }
    
}
