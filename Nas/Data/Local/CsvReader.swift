
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
                let dataArray: [StockDto] = self.parseCSV(content: content)
                single(.success(dataArray))
            } catch {
                single(.failure(LocalError(message: "Cannot read CSV data.")))
            }
            return Disposables.create()
        }
    }
    
    func parseCSV(content: String) -> [StockDto] {
        var dataArray: [StockDto] = []
        let lines = content.components(separatedBy: .newlines).dropFirst()
        
        for line in lines {
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                continue
            }
            
            var fields: [String] = []
            var currentField = ""
            var inQuote = false
            
            for char in line {
                if char == "\"" {
                    inQuote.toggle()
                } else if char == "," && !inQuote {
                    fields.append(currentField.trimmingCharacters(in: .whitespaces))
                    currentField = ""
                } else {
                    currentField.append(char)
                }
            }
            
            fields.append(currentField.trimmingCharacters(in: .whitespaces))
            
            if fields.count == 2 {
                let sName = fields[0].replacingOccurrences(of: "\"", with: "")
                let sPrice = fields[1].toDouble() ?? 0.0
                let dataInstance = StockDto(name: sName, price: sPrice)
                dataArray.append(dataInstance)
            }
        }
        
        return dataArray
    }
    
    func getStocks() -> Single<[StockDto]> {
        return self.readStocks()
            .map { dtos in
                let distinctNames = Set(dtos.map { $0.name })
                return distinctNames.map { name in
                    let prices = dtos.filter { $0.name == name }.map { $0.price }
                    let randomPrice = prices.randomElement() ?? 0.0
                    return StockDto(name: name, price: randomPrice)
                }
            }
    }
    
}
