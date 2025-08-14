//
//  StockRepository.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift

protocol StockRepository {
    func getStocks() -> Single<[Stock]>
}
