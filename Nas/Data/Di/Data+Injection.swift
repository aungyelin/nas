//
//  Data+Injection.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import FactoryKit

extension Container {
    
    var csvReader: Factory<CsvReaderProtocol> {
        Factory(self) { CsvReader.shared }
    }
    
    var apiService: Factory<ApiServiceProtocol> {
        Factory(self) { ApiService.shared }
    }
    
    var newsRepository: Factory<NewsRepository> {
        Factory(self) { NewsRepositoryImpl() }
    }
    
    var stockRepository: Factory<StockRepository> {
        Factory(self) { StockRepositoryImpl() }
    }
    
}
