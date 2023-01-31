//
//  ProductListCollectionCell.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductListCollectionCell: UICollectionViewCell {
    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [productImageView,
                               labelStackView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Const.five
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [productNameLabel,
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
        imageView.layer.cornerRadius = Const.ten
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true

        label.font = UIFont.preferredFont(
            forTextStyle: .title3)

        return label
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = Const.zero
        label.adjustsFontForContentSizeCategory = true

        label.font = UIFont.preferredFont(
            forTextStyle: .caption1)

        return label
    }()
    
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = Const.zero
        label.adjustsFontForContentSizeCategory = true

        label.font = UIFont.preferredFont(
            forTextStyle: .caption1)

        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.adjustsFontForContentSizeCategory = true

        label.font = UIFont.preferredFont(
            forTextStyle: .caption1)

        return label
    }()

    private let bag = AnyCancelTaskBag()

    override init(
        frame: CGRect) {
        super.init(
            frame: frame)
        bind()
    }
    
    @available(*, unavailable)
    required init?(
        coder: NSCoder) {
        super.init(
            coder: coder)
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
            rootStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            rootStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
            rootStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),

            productImageView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor),
            productImageView.heightAnchor.constraint(
                equalTo: productImageView.widthAnchor,
                multiplier: Const.zeroPointEight)
        ])
    }
    
    private func configureForOriginal() {
        discountedPriceLabel.isHidden = true
        originalPriceLabel.textColor = .systemGray

        originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(
            value: Const.zero)
    }
    
    private func configureForBargain() {
        discountedPriceLabel.isHidden = false
        originalPriceLabel.textColor = .systemRed

        originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(
            value: NSUnderlineStyle.single.rawValue)
    }
    
    func fill(with viewModel: ProductsListItemViewModel) {
        Task {
            await productImageView.setImageUrl(viewModel.thumbnail)
        }
        .store(
            in: bag)

        productNameLabel.text = viewModel.name
        originalPriceLabel.text = viewModel.originalPriceText
        discountedPriceLabel.text = viewModel.discountedPriceText
        stockLabel.text = viewModel.stockText
        stockLabel.textColor = viewModel.stockTextColor

        viewModel.isDiscountedItem ==
        true ? configureForBargain() : configureForOriginal()
    }

    enum Const {
        static let zero: Int = 0
        static let zeroPointEight: CGFloat = 0.8
        static let five: CGFloat = 5
        static let ten: CGFloat = 10
    }
}
