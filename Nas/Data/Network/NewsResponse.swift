//
//  NewsResponse.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation

struct NewsResponse: Codable {
    var status: String
    var totalResults: Int
    var articles: [ArticleDto]
}

struct ArticleDto: Codable {
    var source: SourceDto?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct SourceDto: Codable {
    var id: String?
    var name: String?
}
