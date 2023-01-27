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

    init(viewModel: ProductDetailsViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
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
    private func bindViewModel(_ viewModel: ProductDetailsViewModel) {
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
    private func updateUI(_ data: ProductDetailsEntity) {
        title = data.name

        productDetailsView.productNameLabel.text = data.name
        productDetailsView.stockLabel.text = data.stock.description
        productDetailsView.originalPriceLabel.text = data.price.description
        productDetailsView.discountedPriceLabel.text = data.bargainPrice.description
        productDetailsView.productDescriptionTextView.text = data.description

        (data.price != data.bargainPrice) == true ? configureForBargain() : configureForOriginal()
        productDetailsView.stockLabel.textColor = viewModel.isEmptyStock == true ? .systemYellow : .systemGray

        applySnapShot(productDetailImagesDataSource,
                      by: data.images)
    }

    private func configureForOriginal() {
        productDetailsView.discountedPriceLabel.isHidden = true
        productDetailsView.originalPriceLabel.attributedText = productDetailsView.originalPriceLabel.text?.strikeThrough(value: Const.zero)
        productDetailsView.originalPriceLabel.textColor = .systemGray
    }

    private func configureForBargain() {
        productDetailsView.discountedPriceLabel.isHidden = false
        productDetailsView.originalPriceLabel.attributedText = productDetailsView.originalPriceLabel.text?.strikeThrough(value: NSUnderlineStyle.single.rawValue)
        productDetailsView.originalPriceLabel.textColor = .systemRed
    }

    private func applySnapShot(_ dataSource: DataSource, by data: [String]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(data)

        dataSource.apply(snapShot,
                         animatingDifferences: true)
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            productDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productDetailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productDetailsView.imagesCollectionView.heightAnchor.constraint(equalToConstant:
                                                                                view.layer.bounds.height * Const.zeroPintThirtyFive)
        ])
    }

    private func configureNavigationItems() {
        let leftButtonImage = UIImage(systemName: Const.navigationItemBackward)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftButtonImage,
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(didTapBackButton))
        
        guard viewModel.isEqualVendorID else {
            return
        }

        let rightButtonImage = UIImage(systemName: Const.navigationItemArrowUp)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightButtonImage,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapEditButton))
    }

    private func presentActionSheet() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: AlertSetting.modifyAction,
                                       style: .default) { [weak self]_ in
            self?.viewModel.didSelectEditButton()
        }

        let deleteAction = UIAlertAction(title: AlertSetting.deleteAction,
                                         style: .destructive) { [weak self] _ in
            DispatchQueue.main.async {
                self?.presentPasswordCheckAlert()
            }
        }

        let cancelAction = UIAlertAction(title: AlertSetting.cancelAction,
                                         style: .cancel,
                                         handler: nil)

        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)

        actionSheet.modalPresentationStyle = .overFullScreen
        present(actionSheet,
                animated: true,
                completion: nil)
    }

    @MainActor
    private func presentPasswordCheckAlert() {
        let alertController = UIAlertController(title: nil,
                                                message: Const.deleteMessage,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: AlertSetting.confirmAction,
                                          style: .default) { [weak self] _ in
            self?.deleteProduct()
        }

        let cancleAction = UIAlertAction(title: AlertSetting.cancelAction,
                                         style: .destructive)

        alertController.addAction(confirmAction)
        alertController.addAction(cancleAction)
        present(alertController, animated: true)
    }

    private func deleteProduct() {
        Task {
            do {
                try await viewModel.didSelectDeleteButton()
                presentConfirmAlert(message: AlertMessage.deleteSuccess)
            } catch (let error) {
                presentConfirmAlert(message: error.localizedDescription)
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

            cell.fill(imageURL: item, currentIndex: viewModel.returnTotalPage(indexPath.row + Const.one))
        }

        return UICollectionViewDiffableDataSource<DetailsSection, String>(collectionView: productDetailsView.imagesCollectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }

    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapEditButton() {
        DispatchQueue.main.async { [weak self] in
            self?.presentActionSheet()
        }
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
        static let deleteMessage = "정말 삭제하시겠습니까?"
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
