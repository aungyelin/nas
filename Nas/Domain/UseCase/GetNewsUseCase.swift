//
//  GetNewsUseCase.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import RxSwift
import FactoryKit

protocol GetNewsUseCase {
    func execute() -> Single<[Article]>
}

class GetNewsUseCaseImpl: GetNewsUseCase {
    
    @Injected(\.newsRepository) private var newsRepository
    
    func execute() -> RxSwift.Single<[Article]> {
        return newsRepository.getNews()
    }
    
}
