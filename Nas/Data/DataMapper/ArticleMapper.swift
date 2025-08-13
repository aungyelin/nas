//
//  ArticleMapper.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation

extension ArticleDto: DomainMappable {
    
    typealias T = Article
    
    func toDomain() -> Article {
        return Article(
            source: self.source?.toDomain(),
            author: self.author,
            title: self.title,
            description: self.description,
            url: self.url,
            urlToImage: self.urlToImage,
            publishedAt: self.publishedAt,
            content: self.content
        )
    }
    
}

extension SourceDto: DomainMappable {
    
    typealias T = Source
    
    func toDomain() -> Source {
        return Source(
            id: self.id,
            name: self.name
        )
    }
    
}
