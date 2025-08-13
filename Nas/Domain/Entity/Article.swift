//
//  Article.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation

struct Article: Codable {
    var source: Source
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var content: String
}

struct Source: Codable {
    var id: String
    var name: String
}
