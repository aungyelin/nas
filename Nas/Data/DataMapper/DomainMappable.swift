//
//  DomainMappable.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation

protocol DomainMappable {
    associatedtype T
    func toDomain() -> T
}
