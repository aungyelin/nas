//
//  RefreshableConrtoller.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import UIKit
import RxCocoa
import RxSwift

protocol RefreshableConrtoller {
    func setupRefresh(for collectionView: UICollectionView)
    func setupRefresh(for collectionView: UICollectionView, stopRefreshing: Driver<Void>)
    func refresh()
}

extension RefreshableConrtoller where Self: UIViewController {
    
    func setupRefresh(for collectionView: UICollectionView) {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in self?.refresh() })
            .disposed(by: rx.disposeBag)
        
        collectionView.refreshControl = refreshControl
        
    }
    
    func setupRefresh(for collectionView: UICollectionView, stopRefreshing: Driver<Void>) {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] _ in self?.refresh() })
            .disposed(by: rx.disposeBag)
        
        stopRefreshing
            .map { _ in false }
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        
        collectionView.refreshControl = refreshControl
        
    }
    
}
