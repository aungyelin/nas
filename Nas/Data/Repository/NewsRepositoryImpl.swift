//
//  NewsRepositoryImpl.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift
import FactoryKit

class NewsRepositoryImpl: NewsRepository {
    
    @Injected(\.apiService) private var apiService
    
    func getNews() -> Single<[Article]> {
        return apiService.getNews()
            .map { $0.articles.map { dto in dto.toDomain() } }
            .catch { error in
                if let networkError = error as? NetworkError {
                    return Single.error(networkError.toDomain())
                } else {
                    return Single.error(error)
                }
            }
    }
    
}
