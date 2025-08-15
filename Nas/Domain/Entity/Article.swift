//
//  Article.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import Differentiator

struct Article: Codable, IdentifiableType, Equatable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    var identity: String {
        return url ?? UUID().uuidString
    }
}

struct Source: Codable, IdentifiableType, Equatable {
    var id: String?
    var name: String?
    
    var identity: String {
        return id ?? UUID().uuidString
    }
}
