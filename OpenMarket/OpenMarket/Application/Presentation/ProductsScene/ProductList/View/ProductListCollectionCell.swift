//
//  ProductListCollectionCell.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductListCollectionCell: UICollectionViewCell {
    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, labelStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Const.five
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel,
                                                       originalPriceLabel,
                                                       discountedPriceLabel,
                                                       stockLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = Const.five
        stackView.alignment = .center
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.numberOfLines = Const.zero
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.numberOfLines = Const.zero
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.adjustsFontForContentSizeCategory = true
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
        productNameLabel.text = nil
        originalPriceLabel.text = nil
        originalPriceLabel.textColor = .systemGray
        discountedPriceLabel.text = nil
        discountedPriceLabel.textColor = .systemGray
        stockLabel.text = nil
        stockLabel.textColor = .systemGray
    }

    private func bind() {
        contentView.addSubview(rootStackView)
        configureLayouts()
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: Const.ten),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -Const.ten),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Const.ten),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Const.ten),
        ])
    }
    
    private func configureForOriginal() {
        discountedPriceLabel.isHidden = true
        originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(value: Const.zero)
        originalPriceLabel.textColor = .systemGray
    }
    
    private func configureForBargain() {
        discountedPriceLabel.isHidden = false
        originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(value: NSUnderlineStyle.single.rawValue)
        originalPriceLabel.textColor = .systemRed
    }
    
    func fill(with viewModel: ProductsListItemViewModel) {
        productImageView.setImageUrl(viewModel.thumbnail)
        productNameLabel.text = viewModel.name
        originalPriceLabel.text = viewModel.originalPriceText
        discountedPriceLabel.text = viewModel.discountedPriceText
        stockLabel.text = viewModel.stockText

        viewModel.isDiscountedItem == true ? configureForBargain() : configureForOriginal()
        stockLabel.textColor = viewModel.stockTextColor
    }

    enum Const {
        static let zero: Int = 0
        static let five: CGFloat = 5
        static let ten: CGFloat = 10
    }
}
