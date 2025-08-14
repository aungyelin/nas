//
//  ErrorMaper.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation

extension NetworkError: DomainMappable {
    
    typealias T = NasError
    
    func toDomain() -> NasError {
        return NasError(type: .network, message: self.message)
    }
    
}

extension LocalError: DomainMappable {
    
    typealias T = NasError
    
    func toDomain() -> NasError {
        return NasError(type: .csv, message: self.message)
    }
    
}
