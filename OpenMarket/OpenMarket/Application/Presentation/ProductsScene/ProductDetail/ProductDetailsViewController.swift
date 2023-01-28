//
//  ProductDetailsViewController.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductDetailsViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<DetailsSection, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DetailsSection, String>

    private lazy var productDetailsView = ProductDetailsView()
    private lazy var productDetailImagesDataSource = configureDataSource()

    private let viewModel: ProductDetailsViewModel
    private let bag = AnyCancelTaskBag()

    init(
        viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(
        _ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel(viewModel)
        configureNavigationItems()
    }

    private func bind() {
        view.backgroundColor = .systemBackground
        view.addSubview(productDetailsView)
        productDetailsView.imagesCollectionView.delegate = self
        configureLayouts()
    }

    @MainActor
    private func bindViewModel(
        _ viewModel: ProductDetailsViewModel) {
        Task {
            await viewModel.transform()

            guard let state = viewModel.state else {
                return
            }

            switch state {
            case .success(let data):
                updateUI(data)
                await LoadingIndicator.hideLoading()
            case .failed(let errorMessage):
                presentConfirmAlert(message: errorMessage)
            }
        }.store(in: bag)
    }

    @MainActor
    private func updateUI(
        _ data: ProductDetailsEntity) {
        title = data.name

        productDetailsView.productNameLabel.text = data.name
        productDetailsView.stockLabel.text = data.stock.description
        productDetailsView.originalPriceLabel.text = data.price.description
        productDetailsView.discountedPriceLabel.text = data.bargainPrice.description
        productDetailsView.productDescriptionTextView.text = data.description

        (data.price != data.bargainPrice) ==
        true ? configureForBargain() : configureForOriginal()

        productDetailsView.stockLabel.textColor = viewModel.isEmptyStock ==
        true ? .systemYellow : .systemGray

        applySnapShot(
            productDetailImagesDataSource,
            by: data.images)
    }

    private func configureForOriginal() {
        productDetailsView.discountedPriceLabel.isHidden = true

        productDetailsView.originalPriceLabel.attributedText =
        productDetailsView.originalPriceLabel.text?.strikeThrough(
            value: Const.zero)

        productDetailsView.originalPriceLabel.textColor = .systemGray
    }

    private func configureForBargain() {
        productDetailsView.discountedPriceLabel.isHidden = false

        productDetailsView.originalPriceLabel.attributedText =
        productDetailsView.originalPriceLabel.text?.strikeThrough(
            value: NSUnderlineStyle.single.rawValue)

        productDetailsView.originalPriceLabel.textColor = .systemRed
    }

    private func applySnapShot(
        _ dataSource: DataSource,
        by data: [String]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(data)

        dataSource.apply(snapShot,
                         animatingDifferences: true)
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            productDetailsView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailsView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productDetailsView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productDetailsView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productDetailsView.imagesCollectionView.heightAnchor.constraint(
                equalToConstant: view.layer.bounds.height * Const.zeroPintThirtyFive)
        ])
    }

    private func configureNavigationItems() {
        let leftButtonImage = UIImage(
            systemName: Const.navigationItemBackward)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: leftButtonImage,
            style: .done,
            target: self,
            action: #selector(didTapBackButton))
        
        guard viewModel.isEqualVendorID else {
            return
        }

        let rightButtonImage = UIImage(
            systemName: Const.navigationItemArrowUp)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: rightButtonImage,
            style: .plain,
            target: self,
            action: #selector(didTapEditButton))
    }

    @MainActor
    }

    private func deleteProduct() {
        Task {
            await viewModel.didSelectDeleteButton()

            guard let state = viewModel.state else {
                return 
            }

            switch state {
            case .success(_):
                viewModel.popViewController()
            case .failed(let errorMessage):
            }
        }.store(in: bag)
    }

    private func configureDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<ProductDetailsCollectionViewCell, String> {
            [weak self] cell, indexPath, item in
            guard let items = self?.viewModel.items else {
                return
            }
            let viewModel = ProductDetailsItemViewModel(model: items)

            cell.fill(
                imageURL: item,
                currentIndex: viewModel.returnTotalPage(indexPath.row + Const.one))
        }

        return UICollectionViewDiffableDataSource<DetailsSection, String>(
            collectionView: productDetailsView.imagesCollectionView) {
            (collectionView,
             indexPath,
             itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier)
        }
    }

    @objc private func didTapBackButton() {
        viewModel.popViewController()
    }

    @objc private func didTapEditButton() {
        presentActionSheet()
    }

    enum DetailsSection {
        case main
    }

    enum Const {
        static let zero = 0
        static let zeroPintThirtyFive: CGFloat = 0.35
        static let one = 1
        static let navigationItemBackward = "chevron.backward"
        static let navigationItemArrowUp = "square.and.arrow.up"
        static let alertCommonTitle = "알림"
        static let confirmTitle = "확인"
        static let cancelTitle = "취소"
        static let deleteTitle = "삭제"
        static let modifyTitle = "수정"
        static let deleteMessage = "정말 삭제하시겠습니까?"
        static let deleteSuccess = "상품 삭제 완료하였습니다"
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(
            at: indexPath,
            animated: true)
    }
}
