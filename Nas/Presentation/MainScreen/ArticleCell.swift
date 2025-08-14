//
//  ArticleCell.swift
//  Nas
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ArticleCell"

    private let titleLabel = UILabel()
    private let sourceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(sourceLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        sourceLabel.font = .preferredFont(forTextStyle: .subheadline)
        sourceLabel.textColor = .secondaryLabel
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
    }

    func configure(with article: Article) {
        titleLabel.text = article.title
        sourceLabel.text = article.source?.name
    }
    
}
