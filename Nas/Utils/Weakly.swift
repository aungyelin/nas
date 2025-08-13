//
//  Weakly.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation

func Weakly<T: AnyObject, U, V>(_ object: T, _ method: @escaping (T) -> ((U) -> V)) -> ((U) -> V) {
    return { [weak object] parameter in method(object!)(parameter) }
}

func Weakly<T: AnyObject, V>(_ object: T, _ method: @escaping (T) -> (() -> V)) -> (() -> V) {
    return { [weak object] in method(object!)() }
}
