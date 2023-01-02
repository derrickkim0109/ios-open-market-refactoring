//
//  ProductListView.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/12/29.
//

import UIKit

class ProductListView: UIView {
    enum Const {
        static let zero: CGFloat = 0
        static let two = 2
        static let ten: CGFloat = 10
        static let onePoint: CGFloat = 1.0
        static let onePointFive: CGFloat = 1.5
    }
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        configureLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.ten),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Const.ten)
        ])
    }

    private func createLayout() -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Const.onePoint),
                                              heightDimension: .fractionalHeight(Const.onePoint))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Const.onePoint),
                                               heightDimension: .fractionalWidth(Const.onePoint / Const.onePointFive))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: Const.two)

        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(Const.ten)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Const.ten
        section.contentInsets = NSDirectionalEdgeInsets(top: Const.zero,
                                                        leading: Const.ten,
                                                        bottom: Const.zero,
                                                        trailing: Const.ten)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}
