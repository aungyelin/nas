//
//  Driver+Rx.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift
import RxCocoa

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Driver` of source `Driver`'s elements, with `nil` elements filtered out.
     */
    
    func filterNil() -> Driver<Element.Wrapped> {
        return self.flatMap { element -> Driver<Element.Wrapped> in
            guard let value = element.value else {
                return Driver<Element.Wrapped>.empty()
            }
            return Driver<Element.Wrapped>.just(value)
        }
    }
    
    /**
     Unwraps optional elements and replaces `nil` elements with `valueOnNil`.
     - parameter valueOnNil: value to use when `nil` is encountered.
     - returns: `Driver` of the source `Driver`'s unwrapped elements, with `nil` elements replaced by `valueOnNil`.
     */
    
    func replaceNilWith(_ valueOnNil: Element.Wrapped) -> Driver<Element.Wrapped> {
        return self.map { element -> Element.Wrapped in
            guard let value = element.value else {
                return valueOnNil
            }
            return value
        }
    }
    
    /**
     Unwraps optional elements and replaces `nil` elements with result returned by `handler`.
     - parameter handler: `nil` handler function that returns `Driver` of non-`nil` elements.
     - returns: `Driver` of the source `Driver`'s unwrapped elements, with `nil` elements replaced by the handler's returned non-`nil` elements.
     */
    
    func catchOnNil(_ handler: @escaping () -> Driver<Element.Wrapped>) -> Driver<Element.Wrapped> {
        return self.flatMap { element -> Driver<Element.Wrapped> in
            guard let value = element.value else {
                return handler()
            }
            return Driver<Element.Wrapped>.just(value)
        }
    }
}


public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    func mapToVoid() -> Driver<Void> {
        return map { _ in }
    }
    
    /**
     Weakly drives an element handler to an drivable sequence.
     
     - parameter object: Object to invoke onNext method with.
     - parameter onNext: Method to invoke with object for each element in the drivable sequence.
     - returns: Subscription object used to unsubscribe from the drivable sequence.
     */
    func driveNextWeakly<T: AnyObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) -> Disposable {
        return drive(onNext: Weakly(object, onNext))
    }
    
    /**
     Weakly invokes an action for each Next event in the drivable sequence, and propagates all driver messages through the result sequence.
     
     - parameter onNext: Action to invoke for each element in the drivable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    func driveNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> (Self.Element) -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return driveNextWeakly(object, onNext).disposed(by: disposeBag)
    }
}

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element == Void {
    
    func driveNext<T: NSObject>(_ object: T, _ onNext: @escaping (T) -> () -> Void) {
        let disposeBag = (object as? HasDisposeBag)?.disposeBag ?? object.rx.disposeBag
        return drive(onNext: Weakly(object, onNext)).disposed(by: disposeBag)
    }
    
}


public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element: OptionalType, Element.Wrapped: Equatable {
    /**
     Returns an observable sequence that contains only distinct contiguous elements according to equality operator.
     
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    
    func distinctUntilChanged() -> Driver<Element> {
        return self.distinctUntilChanged { (lhs, rhs) -> Bool in
            return lhs.value == rhs.value
        }
    }
}


extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    public func flatMap<R>(_ selector: @escaping (Element) throws -> Observable<R>)
    -> Observable<R> {
        return self.asObservable().flatMap(selector)//.asDriver(onErrorDriveWith: .empty())
    }
}


extension SharedSequenceConvertibleType {
    /*func flatMapLoading<Sharing, R>(_ loading: Variable<Bool>, _ selector: @escaping (Element) -> SharedSequence<Sharing, R>) -> SharedSequence<Sharing, R> /*where Sharing : SharingStrategyProtocol*/ {
        return flatMap { selector($0) }.attach(loading)
    }
    
    func flatMapAttach<Sharing, R>(_ button: LoadingButton, _ selector: @escaping (Element) -> SharedSequence<Sharing, R>) -> SharedSequence<Sharing, R> /*where Sharing : SharingStrategyProtocol*/ {
        return flatMap { selector($0) }.attach(button)
    }
     */
}
