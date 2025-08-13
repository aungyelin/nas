//
//  NewsRepositoryImpl.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift

class NewsRepositoryImpl: NewsRepository {
    
    func getNews() -> RxSwift.Single<[Article]> {
        return Single.just([]).delay(.seconds(2), scheduler: MainScheduler.instance)
    }
    
}
