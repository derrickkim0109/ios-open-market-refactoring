//
//  ProductDetailsView.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

import UIKit

final class ProductDetailsView: UIView {
    private let rootScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imagesCollectionView,
                                                       productInfoLabelStackView,
                                                       productDescriptionTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Const.ten
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Const.ten,
                                               left: Const.ten,
                                               bottom: Const.ten,
                                               right: Const.ten)
        return stackView
    }()

    lazy var imagesCollectionView: UICollectionView = {
        let collectioView = UICollectionView(frame: .zero,
                                             collectionViewLayout: createLayout())
        collectioView.translatesAutoresizingMaskIntoConstraints = false
        return collectioView
    }()

    private lazy var productInfoLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel,
                                                       productPriceAndStockStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Const.zero
        stackView.alignment = .firstBaseline
        return stackView
    }()

    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var productPriceAndStockStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stockLabel,
                                                       originalPriceLabel,
                                                       discountedPriceLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Const.five
        stackView.alignment = .fill
        return stackView
    }()

    let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .callout)
        return textView
    }()

    init() {
        super.init(frame: .zero)
        bind()
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        configureRootScrollViewLayouts()
        configureLayouts()
    }

    private func configureRootScrollViewLayouts() {
        addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)

        let heightAnchor = rootScrollView.heightAnchor.constraint(equalTo: rootScrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: topAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: rootScrollView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.bottomAnchor),
            rootStackView.widthAnchor.constraint(equalTo: rootScrollView.widthAnchor)
        ])
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Const.onePointZero),
                                              heightDimension: .fractionalHeight(Const.onePointZero))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Const.onePointZero),
                                               heightDimension: .fractionalWidth(Const.zeroPointEight))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: Const.one)
        group.contentInsets = NSDirectionalEdgeInsets(top: Const.ten,
                                                      leading: Const.ten,
                                                      bottom: Const.ten,
                                                      trailing: Const.ten)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(Const.zero)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    enum Const {
        static let zero: CGFloat = 0
        static let onePointZero: CGFloat = 1.0
        static let one = 1
        static let zeroPointEight: CGFloat = 0.8
        static let five: CGFloat = 5
        static let ten: CGFloat = 10
    }
}
