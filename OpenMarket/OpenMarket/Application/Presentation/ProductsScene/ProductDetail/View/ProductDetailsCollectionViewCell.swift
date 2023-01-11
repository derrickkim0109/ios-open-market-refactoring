//
//  ProductDetailsCollectionViewCell.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductDetailsCollectionViewCell: UICollectionViewCell {
    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView,
                                                       productImageQuantityLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.alignment = .fill
        
        return stackView
    }()
    
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
        contentView.addSubview(rootStackView)
        productImageView.setContentCompressionResistancePriority(.defaultLow,
                                                                 for: .vertical)
        configureLayouts()
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            rootStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),

            productImageQuantityLabel.heightAnchor.constraint(equalTo: rootStackView.heightAnchor,
                                                      multiplier: 0.1),
        ])
    }
    
    func fill(imageURL: String, currentIndex: String) {
        productImageView.setImageUrl(imageURL)
        productImageQuantityLabel.text = currentIndex
    }
}
