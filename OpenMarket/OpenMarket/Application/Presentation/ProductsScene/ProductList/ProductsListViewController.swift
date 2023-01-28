//
//  OpenMarket - ProductsListViewController.swift
//  Created by 데릭, 수꿍.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ProductsListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<ListSection, ProductEntity>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, ProductEntity>
    
    private lazy var dataSource = configureDataSource()
    private var snapshot = Snapshot()
    
    private var initialPageInfo: (pageNumber: Int,
                                  itemsPerPage: Int) = (RequestName.initialPageNumber,
                                                        RequestName.initialItemPerPage)
    private let viewModel: ProductsListViewModel
    private let bag = AnyCancelTaskBag()
    
    private lazy var productListView: ProductListView = ProductListView()
    
    private let productEnrollmentImageViewButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemBlue

        imageView.image = UIImage(
            systemName: Const.systemCircleImageName)

        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    init(
        viewModel: ProductsListViewModel) {
        self.viewModel = viewModel

        super.init(
            nibName: nil,
            bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(
        coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(
        _ animated: Bool) {
        super.viewWillAppear(animated)

        bindViewModel(
            by: initialPageInfo)
    }
    
    private func bind() {
        view.backgroundColor = .systemBackground
        view.addSubview(productListView)
        view.addSubview(productEnrollmentImageViewButton)
        
        productListView.collectionView.delegate = self
        
        configureLayouts()
        configureRefreshControl()
        setupProductEnrollmentImageViewGesture()
    }
    
    private func bindViewModel(
        by input: (pageNumber: Int,
                   itemsPerPage: Int)) {
        Task {
            await viewModel.transform(
                input: input)
            
            guard let state = viewModel.state else {
                return
            }
            
            switch state {
            case .success(let data):
                applySnapshot(by: data)
            case .failed(let errorMessage):
                await AlertControllerBulider.Builder()
                    .setMessag(errorMessage)
                    .build()
                    .present()
            }
        }.store(in: bag)
    }
    
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            productListView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            productListView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productListView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productListView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productEnrollmentImageViewButton.widthAnchor.constraint(
                equalToConstant: Const.fifty),
            productEnrollmentImageViewButton.heightAnchor.constraint(
                equalToConstant: Const.fifty),
            productEnrollmentImageViewButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Const.twenty),
            productEnrollmentImageViewButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Const.twenty)
        ])
    }
    
    private func configureDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<ProductListCollectionCell, ProductEntity> {
            cell, indexPath, item in
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.borderWidth = Const.borderWidthOnePoint
            cell.layer.cornerRadius = Const.cornerRadiusTenPoint
            
            cell.fill(with: ProductsListItemViewModel(
                model: item))
        }
        
        return UICollectionViewDiffableDataSource<ListSection,ProductEntity>(
            collectionView: productListView.collectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier)
        }
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        return snapshot
    }
    
    @MainActor
    private func applySnapshot(
        by data: [ProductEntity]) {
        if initialPageInfo.pageNumber == RequestName.initialPageNumber {
            snapshot = makeSnapshot()
        }
        
        snapshot.appendItems(data)
        dataSource.apply(
            snapshot,
            animatingDifferences: false)
    }
    
    private func configureRefreshControl() {
        productListView.collectionView.refreshControl = UIRefreshControl()
        productListView.collectionView.refreshControl?.addTarget(
            self,
            action: #selector(didSetRefreshControl),
            for: .valueChanged)
    }
    
    private func resetData() {
        initialPageInfo = (
            RequestName.initialPageNumber,
            RequestName.initialItemPerPage)

        bindViewModel(
            by: initialPageInfo)

        productListView.collectionView.refreshControl?.endRefreshing()
    }
    
    private func setupProductEnrollmentImageViewGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapEnrollmentButton))
        
        productEnrollmentImageViewButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapEnrollmentButton() {
        viewModel.didTapEnrollmentButton()
    }
    
    @objc private func didSetRefreshControl() {
        resetData()
    }
    
    enum ListSection {
        case main
    }
    
    enum Const {
        static let borderWidthOnePoint: CGFloat = 1.0
        static let cornerRadiusTenPoint: CGFloat = 10.0
        static let plus = "+"
        static let one = 1
        static let twenty: CGFloat = 20
        static let fifty: CGFloat = 50
        static let hundred: CGFloat = 100
        static let systemCircleImageName = "plus.circle.fill"
    }
}

extension ProductsListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        guard let product = dataSource.itemIdentifier(
            for: indexPath) else {
            collectionView.deselectItem(
                at: indexPath,
                animated: true)
            return
        }
        
        viewModel.didSelectItem(product)
    }
    
    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool) {
        reloadDataDidScrollDown(productListView.collectionView)
    }
    
    private func reloadDataDidScrollDown(
        _ collectionView: UICollectionView) {
        let trigger = (collectionView.contentSize.height -
                       collectionView.bounds.size.height) + Const.hundred
        
        if collectionView.contentOffset.y > trigger {
            initialPageInfo = (initialPageInfo.pageNumber + Const.one,
                               RequestName.initialItemPerPage)
            bindViewModel(by: initialPageInfo)
        }
    }
}
