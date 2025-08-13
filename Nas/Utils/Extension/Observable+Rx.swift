//
//  Observable+Rx.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: Optionals
// Credit to: https://github.com/RxSwiftCommunity/RxOptional

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    /// Cast `Optional<Wrapped>` to `Wrapped?`
    public var value: Wrapped? {
        return self
    }
}

public extension ObservableType where Element: OptionalType {

    /**
     Unwrap and filter out nil values.
     - returns: Observbale of only successfully unwrapped values.
     */
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else {
                return Observable<Element.Wrapped>.empty()
            }
            return Observable<Element.Wrapped>.just(value)
        }
    }

    /**
     Unwraps optional and replace nil values with value.
     - parameter valueOnNil: Value to emit when nil is found.
     - returns: Observable of unwrapped value or nilValue.
     */
    func replaceNilWith(valueOnNil: Element.Wrapped) -> Observable<Element.Wrapped> {
        return self.map { element -> Element.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }

}

// MARK: Void

public extension ObservableType {
    
    /**
     Maps to void observable.
     - returns: Observable of voids
     */
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func mapToVoidDriver() -> Driver<Void> {
        return mapToVoid().asDriver(onErrorDriveWith: .empty())
    }
    
}

// MARK: Subscribe Finished

public extension ObservableType {
    
    /**
     Subscribes a termination handler to an observable sequence.
     
     - parameter onDisposed: Action to invoke upon gracefull or errored termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeFinished(onFinished: @escaping () -> Void) -> Disposable {
        return subscribe { event in
            switch event {
            case .error, .completed: onFinished()
            default: break
            }
        }
    }
    
}

// MARK: Subscribe Weakly

public extension ObservableType {
    
    /**
     Weakly subscribes an element handler to an observable sequence.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    func subscribeNextWeakly<T: AnyObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) -> Disposable {
        return subscribe(onNext: Weakly(object, onNext))
    }
    
    /**
     Weakly subscribes an element handler to an observable sequence and adds it's subscription object to `object.rx.disposeBag`.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the observable sequence.
     */
    func subscribeNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return subscribeNextWeakly(object, onNext).disposed(by: disposeBag)
    }
}

public extension ObservableType where Element == Void {
    
    func subscribeNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> () -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return subscribe(onNext: Weakly(object, onNext)).disposed(by: disposeBag)
    }
}


extension ObservableType {
//    TODO. IMPLEMENT
//    public func flatMapLoading<O>(_ loading: Variable<Bool>, _ selector: @escaping (Self.E)) -> RxSwift.Observable<O.E> where O : ObservableConvertibleType {
//        let soem = flatMap { selector($0) }
//        return flatMap { selector($0) }//.attach(loading) }
//    }
}
