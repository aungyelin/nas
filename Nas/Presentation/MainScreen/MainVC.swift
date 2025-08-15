//
//  ViewController.swift
//  Nas
//
//  Created by Ye Lin Aung on 12/08/2025.
//

import UIKit
import RxDataSources

class MainVC: UIViewController, RefreshableConrtoller {
    
    private let mainVM = MainVM.shared
    
    private var collectionView: UICollectionView!
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MainSection>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.configureDataSource()
        self.subscribeData()
        
        self.mainVM.getStockDataChanges()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.beginRefreshing()
    }
    
    private func setupUI() {
        self.setupCollectionView()
        self.setupRefresh(for: collectionView, stopRefreshing: mainVM.refreshingDriver.filter{ !$0 }.mapToVoid())
    }
    
    private func subscribeData() {
        mainVM.sectionDriver
            .drive(collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: rx.disposeBag)
        
        mainVM.errorDriver
            .drive(onNext: { [weak self] error in
                self?.showAlert(error: error)
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func showAlert(error: NasError) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - RefreshableConrtoller

extension MainVC {
    
    func refresh() {
        self.mainVM.fetchAllData()
    }
    
}

// MARK: - Layout

extension MainVC {
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.register(StockCell.self, forCellWithReuseIdentifier: StockCell.reuseIdentifier)
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: ArticleCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionType = self.dataSource?[sectionIndex] else { return nil }
            
            switch sectionType {
            case .stocks: return self.createStocksSection()
            case .highlightedNews: return self.createHighlightedNewsSection()
            case .news: return self.createNewsSection()
            }
        }
        return layout
    }
    
    private func createStocksSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createHighlightedNewsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createNewsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
}

// MARK: - CollectionView

extension MainVC {
    
    private func configureDataSource() {
        
        self.dataSource = RxCollectionViewSectionedReloadDataSource<MainSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch item {
                case .stock(let stock):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockCell.reuseIdentifier, for: indexPath) as! StockCell
                    cell.configure(with: stock)
                    return cell
                case .news(let article):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as! ArticleCell
                    cell.configure(with: article)
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath
                ) as! SectionHeaderView
                header.configure(with: dataSource[indexPath.section].title)
                return header
            }
        )
        
    }
    
}
