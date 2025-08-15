//
//  MainVC.swift
//  Nas
//
//  Created by Ye Lin Aung on 12/08/2025.
//

import UIKit
import RxDataSources

class MainVC: UIViewController, RefreshableConrtoller {
    
    private let mainVM = MainVM.shared
    
    private var collectionView: UICollectionView!
    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<MainSection>!
    
    
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
        collectionView.register(HighlightNewsCell.self, forCellWithReuseIdentifier: HighlightNewsCell.reuseIdentifier)
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(65))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createHighlightedNewsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(collectionView.frame.width - 40), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
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
        
        self.dataSource = RxCollectionViewSectionedAnimatedDataSource<MainSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch item {
                case .stock(let stock, let viewModel):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockCell.reuseIdentifier, for: indexPath) as! StockCell
                    cell.configure(with: stock, viewModel: viewModel)
                    return cell
                case .highlightNews(let article):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightNewsCell.reuseIdentifier, for: indexPath) as! HighlightNewsCell
                    cell.configure(with: article)
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
