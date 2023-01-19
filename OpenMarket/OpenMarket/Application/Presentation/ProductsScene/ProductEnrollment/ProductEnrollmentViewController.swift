////
////  ProductEnrollmentViewController.swift
////  OpenMarket
////
////  Created by 데릭, 수꿍.
////

import UIKit

final class ProductEnrollmentViewController: UIViewController {
    private let productEnrollmentView = ProductEnrollmentView(pagePurpose: .enrollment)

    private let viewModel: ProductEnrollmentViewModel
    private let bag = AnyCancelTaskBag()

    init(viewModel: ProductEnrollmentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        view.backgroundColor = .systemBackground
        view.addSubview(productEnrollmentView)
        productEnrollmentView.productImagePicker.delegate = self
        productEnrollmentView.enrollmentButton.addTarget(self,
                                                        action: #selector(didTapImagePickerButton(_:)),
                                                        for: .touchUpInside)

        configureLayouts()
        configureNavigationItems()
    }

    private func bindViewModel() {
        Task {
            let data = productEnrollmentView.convertTextToTypeDTO()
            guard let images = makeProductImages() else { return }

            let input = (data, images)
            await viewModel.didSelectCompletionButton(input: input)

            guard let state = viewModel.state else { return }
            switch state {
            case .failed(let error):
                self.presentConfirmAlert(message: error.localizedDescription)
            }
        }.store(in: bag)
    }

    private func configureLayouts() {
        NSLayoutConstraint.activate([
            productEnrollmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productEnrollmentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productEnrollmentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productEnrollmentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            productEnrollmentView.imageAndPickerButtonScrollView.heightAnchor.constraint(equalToConstant: view.layer.bounds.width * Const.zeroPointThree)
        ])
    }
    
    private func configureNavigationItems() {
        title = Const.productEnrollment
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(didTapDoneButton))
    }
    
    private func makeProductImages() -> [ProductImageDTO]? {
        var productImagesArray: [ProductImageDTO] = []

        for i in 0..<productEnrollmentView.imageStackView.subviews.count {
            guard let imageView = productEnrollmentView.imageStackView.subviews[i].subviews[0] as? UIImageView,
                  let image = imageView.image else { return nil }

            let productImage = ProductImageDTO(data: image.compress() ?? Data(),
                                               mimeType: Const.pngType)

            productImagesArray.append(productImage)
        }

        return productImagesArray
    }

    @objc private func didTapCancelButton() {
        viewModel.didTapCancelButton()
    }
    
    @objc private func didTapDoneButton() {
        bindViewModel()
    }

    @objc private func didTapImagePickerButton(_ sender: UIButton) {
        guard productEnrollmentView.imageStackView.subviews.count < 5 else {
            presentConfirmAlert(message: AlertMessage.exceedImages)
            return
        }

        self.present(self.productEnrollmentView.productImagePicker,
                    animated: true)
    }

    enum Const {
        static let zeroPointThree: CGFloat = 0.3
        static let productEnrollment = "상품등록"
        static let pngType = "png"
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProductEnrollmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage = UIImage()
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }

        let newView = newImage.configureSquareImageView()

        productEnrollmentView.addSquareImageView(newView)
        picker.dismiss(animated: true,
                       completion: nil)
    }
}
