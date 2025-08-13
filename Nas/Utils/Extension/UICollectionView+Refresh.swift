//
//  UICollectionView+Refresh.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import UIKit

public extension UICollectionView {
    
    func beginRefreshing() {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else { return }
        
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
        
        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        setContentOffset(contentOffset, animated: true)
    }
    
    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
    
}
