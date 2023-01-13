//
//  OpenMarket - ProductsListViewController.swift
//  Created by 데릭, 수꿍.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ProductsListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<ListSection, ProductEntity>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, ProductEntity>

    private var initialPageInfo: (pageNumber: Int, itemsPerPage: Int) = (RequestName.initialPageNumber,
                                                                         RequestName.initialItemPerPage)
    private let viewModel: ProductsListViewModel
    private var productListTask: Task<Void, Error>?

    private lazy var dataSource = configureDataSource()
    private var snapshot = Snapshot()

    private lazy var productListView: ProductListView = ProductListView()

    init(viewModel: ProductsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        productListTask?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel(by: initialPageInfo)
    }

    private func bind() {
        view.backgroundColor = .white
        view.addSubview(productListView)
        productListView.collectionView.delegate = self

        configureLayouts()
        configureRefreshControl()
    }

    private func bindViewModel(by input: (pageNumber: Int, itemsPerPage: Int)) {
        productListTask = Task {
            await viewModel.transform(input: input)

            guard let state = viewModel.state else { return }

            switch state {
            case .success(let data):
                applySnapshot(by: data)
            case .failed(let error):
                presentConfirmAlert(message: error.localizedDescription)
            }
        }
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            productListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<ProductListCollectionCell, ProductEntity> { cell, indexPath, item in
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.borderWidth = Const.borderWidthOnePoint
            cell.layer.cornerRadius = Const.cornerRadiusTenPoint

            cell.fill(with: ProductsListItemViewModel(model: item))
        }

        return UICollectionViewDiffableDataSource<ListSection, ProductEntity>(collectionView: productListView.collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
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
    private func applySnapshot(by data: [ProductEntity]) {
        if initialPageInfo.pageNumber == RequestName.initialPageNumber {
            snapshot = makeSnapshot()
        }

        snapshot.appendItems(data)
        dataSource.apply(snapshot,
                         animatingDifferences: false)
    }
    
    private func configureRefreshControl() {
        productListView.collectionView.refreshControl = UIRefreshControl()
        productListView.collectionView.refreshControl?.addTarget(self,
                                                            action:#selector(didSetRefreshControl),
                                                            for: .valueChanged)
    }
    
    private func resetData() {
        initialPageInfo = (RequestName.initialPageNumber, RequestName.initialItemPerPage)
        bindViewModel(by: initialPageInfo)
        productListView.collectionView.refreshControl?.endRefreshing()
    }
    
    @objc private func didSetRefreshControl() {
        resetData()
    }

    @objc private func plusButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.didTapPlusButton()
    }

    enum ListSection {
        case main
    }

    enum Const {
        static let borderWidthOnePoint: CGFloat = 1.0
        static let cornerRadiusTenPoint: CGFloat = 10.0
        static let plus = "+"
        static let one = 1
        static let hundred: CGFloat = 100
    }
}

extension ProductsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath,
                                        animated: true)
            return
        }
        
        viewModel.didSelectItem(product)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        reloadDataDidScrollDown(productListView.collectionView)
    }
    
    private func reloadDataDidScrollDown(_ collectionView: UICollectionView) {
        let trigger = (collectionView.contentSize.height - collectionView.bounds.size.height) + Const.hundred
        
        if collectionView.contentOffset.y > trigger {
            initialPageInfo = (initialPageInfo.pageNumber + Const.one, RequestName.initialItemPerPage)
            bindViewModel(by: initialPageInfo)
        }
    }
}
