//
//  GetStockUseCase.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift
import FactoryKit

protocol GetStockUseCase {
    func execute() -> Single<[Stock]>
}

class GetStockUseCaseImpl: GetStockUseCase {
    
    @Injected(\.stockRepository) private var stockRepository
    
    func execute() -> Single<[Stock]> {
        return stockRepository.getStocks()
    }
    
}
