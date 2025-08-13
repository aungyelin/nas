//
//  NasError.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import Alamofire

struct NasError: Error {
    enum ErrorType {
        case network
        case json
        case unknown
    }
    
    let type: ErrorType
    let message: String
}
