//
//  SharedSequenceConvertibleType.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import RxCocoa

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    func attach(_ loading: BehaviorRelay<Bool>) -> Driver<Element> {
        return self.do(
            onNext:      { [weak loading] _ in loading?.accept(false) },
            onSubscribe: { [weak loading] in loading?.accept(true)    },
            onDispose:   { [weak loading] in loading?.accept(false)   }
        )
    }
    
}
