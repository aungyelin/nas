//
//  MainSection.swift
//  Nas
//
//  Created by Ye Lin Aung on 14/08/2025.
//

import RxDataSources

enum MainSection {
    case stocks             (items: [MainSectionItem])
    case highlightedNews    (items: [MainSectionItem])
    case news               (items: [MainSectionItem])
}

extension MainSection: AnimatableSectionModelType {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .stocks:           return "stocks"
        case .highlightedNews:  return "highlightedNews"
        case .news:             return "news"
        }
    }
}

extension MainSection: SectionModelType {
    typealias Item = MainSectionItem
    
    var items: [MainSectionItem] {
        switch self {
        case .stocks(let items): return items
        case .highlightedNews(let items): return items
        case .news(let items): return items
        }
    }
    
    init(original: MainSection, items: [MainSectionItem]) {
        switch original {
        case .stocks: self = .stocks(items: items)
        case .highlightedNews: self = .highlightedNews(items: items)
        case .news: self = .news(items: items)
        }
    }
}

enum MainSectionItem {
    case stock              (stock: Stock)
    case news               (article: Article)
}

extension MainSectionItem: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .stock(stock: let stock): return stock.identity
        case .news(article: let article): return article.identity
        }
    }
}
