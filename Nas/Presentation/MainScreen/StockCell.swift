//
//  StockCell.swift
//  Nas
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import UIKit

class StockCell: UICollectionViewCell {
    
    static let reuseIdentifier = "StockCell"

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        priceLabel.font = .preferredFont(forTextStyle: .subheadline)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
    }

    func configure(with stock: Stock, viewModel: MainVM) {
        nameLabel.text = stock.name
        
        viewModel.stocksDriver
            .filterNil()
            .do(onNext: { stocks in
                if let price = stocks.filter({ $0.identity == stock.identity }).first?.price {
                    self.priceLabel.text = String(format: "%.2f", price)
                }
            })
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
}
