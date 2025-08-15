//
//  Date.swift
//  Nas
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import Foundation

let nasDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
let nasDisplayDateFormat = "dd-MM-yyyy hh:mm a"

extension Date {
    
    func toString(with format: String = nasDisplayDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func toDisplayFormat() -> String {
        return self.toString()
    }
    
}

extension String {
    
    func toDate(with format: String = nasDateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
    
}
