//
//  ApiService.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift

class ApiService {
    
    static let shared = ApiService()
    
    private let networkManager = NetworkManager.shared
    
    
    func getNews() -> Single<NewsResponse> {
        return networkManager.request(endpoint: "/NewsAPI/everything/cnn.json")
    }
    
}
