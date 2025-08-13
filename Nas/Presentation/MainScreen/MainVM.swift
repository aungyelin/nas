//
//  MainVM.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift
import FactoryKit

class MainVM: NSObject, HasDisposeBag {
    
    static let shared = MainVM()
    
    @Injected(\.getNewsUseCase) private var getNewsUseCase
    
    
    func fetchNews() {
        getNewsUseCase.execute()
            .subscribe(
                onSuccess: { model in
                    print("fetchNews: success")
                },
                onFailure: { error in
                    print("fetchNews: failed by error \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
    
}
