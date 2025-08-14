//
//  AttachLoading.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType {
    
    func attach(_ loading: BehaviorRelay<Bool>?) -> SharedSequence<SharingStrategy, Element> {
        return self.do(
            onNext:      { [weak loading] _ in loading?.accept(false) },
            onSubscribe: { [weak loading] in loading?.accept(true)    },
            onDispose:   { [weak loading] in loading?.accept(false)   }
        )
    }
    
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    func attach(_ loading: BehaviorRelay<Bool>) -> Driver<Element> {
        return self.do(
            onNext:      { [weak loading] _ in loading?.accept(false) },
            onSubscribe: { [weak loading] in loading?.accept(true)    },
            onDispose:   { [weak loading] in loading?.accept(false)   }
        )
    }
    
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    
    func attach(_ loading: BehaviorRelay<Bool>?) -> Single<Element> {
        return self.do(
            onSuccess:   { [weak loading] _ in loading?.accept(false) },
            onSubscribe: { [weak loading] in loading?.accept(true)    },
            onDispose:   { [weak loading] in loading?.accept(false)   }
        )
    }
    
}

extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Never {
    
    func attach(_ loading: BehaviorRelay<Bool>?) -> Completable {
        return self.do(
            onError:     { [weak loading] _ in loading?.accept(false) },
            onCompleted: { [weak loading] in loading?.accept(false) },
            onSubscribe: { [weak loading] in loading?.accept(true) },
            onDispose:   { [weak loading] in loading?.accept(false) }
        )
    }
    
}

extension ObservableType {
    
    func attach(_ loading: BehaviorRelay<Bool>?) -> Observable<Element> {
        return self.do(
            onNext:      { [weak loading] _ in loading?.accept(false) },
            onSubscribe: { [weak loading] in loading?.accept(true)    },
            onDispose:   { [weak loading] in loading?.accept(false)   }
        )
    }
    
}
