//
//  StockRepositoryImpl.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift

class StockRepositoryImpl: StockRepository {
    
    func getStocks() -> Single<[Stock]> {
        return CsvReader.shared.getStocks()
            .map { dtos in dtos.map { $0.toDomain() } }
            .catch { error in
                if let localError = error as? LocalError {
                    return Single.error(localError.toDomain())
                } else {
                    return Single.error(error)
                }
            }
    }
    
}
