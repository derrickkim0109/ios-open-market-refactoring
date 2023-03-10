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
    
    init(
        viewModel: ProductEnrollmentViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
    
    @available(*, unavailable)
    required init?(
        coder: NSCoder) {
            fatalError(Const.fatalErrorComment)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        view.backgroundColor = .systemBackground
        view.addSubview(productEnrollmentView)
        productEnrollmentView.productImagePicker.delegate = self
        
        productEnrollmentView.enrollmentButton.addTarget(
            self,
            action: #selector(didTapImagePickerButton(_:)),
            for: .touchUpInside)
        
        configureLayouts()
        configureNavigationItems()
    }
    
    private func bindViewModel() {
        Task {
            let data = productEnrollmentView.convertTextToTypeDTO()
            guard let images = makeProductImages() else {
                return
            }
            
            let input = (data, images)
            
            await viewModel.didSelectEnrollmentButton(
                input: input)
            
            guard let state = viewModel.state else {
                return
            }
            
            switch state {
            case .failed(let errorMessage):
                await AlertControllerBulider.Builder()
                    .setTitle(Const.alertCommonTitle)
                    .setMessag(errorMessage)
                    .setConfrimText(Const.confirmTitle)
                    .build()
                    .present()
            }
        }.store(in: bag)
    }
    
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            productEnrollmentView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            productEnrollmentView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            productEnrollmentView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productEnrollmentView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            productEnrollmentView.imageAndPickerButtonScrollView.heightAnchor.constraint(
                equalToConstant: view.layer.bounds.width * Const.zeroPointThree)
        ])
    }
    
    private func configureNavigationItems() {
        title = Const.productEnrollment
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancelButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDoneButton))
    }
    
    private func makeProductImages() -> [ProductImageEntity]? {
        var productImagesArray: [ProductImageEntity] = []
        
        for i in 0..<productEnrollmentView.imageStackView.subviews.count {
            guard let imageView =
                    productEnrollmentView.imageStackView.subviews[i].subviews[0] as? UIImageView,
                  let image = imageView.image else {
                return nil
            }
            
            let productImage = ProductImageEntity(
                data: image.compress() ?? Data(),
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
    
    @objc private func didTapImagePickerButton(
        _ sender: UIButton) {
            guard productEnrollmentView.imageStackView.subviews.count < 5 else {
                Task {
                    await AlertControllerBulider.Builder()
                        .setTitle(Const.alertCommonTitle)
                        .setMessag(Const.exceedImages)
                        .setConfrimText(Const.confirmTitle)
                        .build()
                        .present()
                }.store(
                    in: bag)
                return
            }
            
            present(
                self.productEnrollmentView.productImagePicker,
                animated: true)
        }
    
    enum Const {
        static let zeroPointThree: CGFloat = 0.3
        static let productEnrollment = "상품등록"
        static let pngType = "png"
        static let exceedImages = "이미지를 추가할 수 없습니다"
        static let fatalErrorComment = "init(coder:) has not been implemented"
        static let alertCommonTitle = "알림"
        static let confirmTitle = "확인"
    }
}

extension ProductEnrollmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var newImage = UIImage()
            
            if let possibleImage =
                info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                newImage = possibleImage
            } else if let possibleImage =
                        info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                newImage = possibleImage
            }
            
            let newView = newImage.configureSquareImageView()
            
            productEnrollmentView.addSquareImageView(newView)
            picker.dismiss(
                animated: true,
                completion: nil)
        }
}
