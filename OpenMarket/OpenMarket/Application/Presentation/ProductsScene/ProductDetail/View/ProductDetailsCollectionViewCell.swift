//
//  ProductDetailsCollectionViewCell.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductDetailsCollectionViewCell: UICollectionViewCell {
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let productImageQuantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productImageQuantityLabel.text = nil
    }

    private func bind() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productImageQuantityLabel)
        productImageView.setContentCompressionResistancePriority(.defaultLow,
                                                                 for: .vertical)
        configureLayouts()
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.bottomAnchor.constraint(equalTo: productImageQuantityLabel.topAnchor,
                                                     constant: -Const.ten),

            productImageQuantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageQuantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageQuantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func fill(imageURL: String,
              currentIndex: String) {
        productImageView.setImageUrl(imageURL)
        productImageQuantityLabel.text = currentIndex
    }

    enum Const {
        static let ten: CGFloat = 10
    }
}
