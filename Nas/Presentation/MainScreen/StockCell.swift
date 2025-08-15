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
    private let currencyLabel = UILabel()

    
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
        contentView.addSubview(currencyLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            currencyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            currencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: currencyLabel.leadingAnchor, constant: -12),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        nameLabel.numberOfLines = 1
        priceLabel.numberOfLines = 1
        
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        priceLabel.font = .preferredFont(forTextStyle: .subheadline)
        currencyLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        currencyLabel.text = "USD"
        currencyLabel.textAlignment = .right
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
    }

    func configure(with stock: Stock, viewModel: MainVM) {
        nameLabel.text = stock.name
        
        viewModel.stocksDriver
            .filterNil()
            .do(onNext: { stocks in
                if let price = stocks.filter({ $0.identity == stock.identity }).first?.price {
                    if price < 0 {
                        self.priceLabel.text = getMoneyFormat(value: price * -1)
                        self.priceLabel.textColor = UIColor.red
                    } else {
                        self.priceLabel.text = getMoneyFormat(value: price)
                        self.priceLabel.textColor = UIColor.green
                    }
                }
            })
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
}
