
//
//  CsvReader.swift
//  Nas
//
//  Created by Ye Lin Aung on 14/08/2025.
//

import Foundation
import RxSwift

class CsvReader {
    
    static let shared = CsvReader()
    
    func readStocks() -> Single<[StockDto]> {
        
        return Single.create { single in
            
            guard let fileURL = Bundle.main.url(forResource: "stocks", withExtension: "csv") else {
                single(.failure(LocalError(message: "CSV file not found in bundle.")))
                return Disposables.create()
            }
            
            do {
                let content = try String(contentsOf: fileURL, encoding: .utf8)
                let lines = content.components(separatedBy: .newlines)
                let dataLines = lines.dropFirst()
                
                var dataArray: [StockDto] = []
                
                for line in dataLines {
                    let fields = line.components(separatedBy: ",")
                    
                    if fields.count == 2 {
                        let sName = String(fields[0])
                        let sPrice = fields[1].toDouble() ?? 0.0
                        let dataInstance = StockDto(stock: sName, price: sPrice)
                        dataArray.append(dataInstance)
                    }
                }
                
                single(.success(dataArray))
            } catch {
                single(.failure(LocalError(message: "Cannot read CSV data.")))
            }
            
            return Disposables.create()
        }
        
    }
    
    func getStocks() -> Single<[StockDto]> {
        return self.readStocks()
            .map { dtos in
                let distinctNames = Set(dtos.map { $0.stock })
                return distinctNames.map { name in
                    let prices = dtos.filter { $0.stock == name }.map { $0.price }
                    let randomPrice = prices.randomElement() ?? 0.0
                    return StockDto(stock: name, price: randomPrice)
                }
            }
    }
    
}
