//
//  ProductEnrollmentVIew.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

import UIKit

enum PagePurpose: String {
    case enrollment = "상품등록"
    case modification = "상품수정"
}

final class ProductEnrollmentView: UIView {
    private let rootScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageAndPickerButtonScrollView,
                                                       textFieldStackView,
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

    let productImagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true

        return imagePicker
    }()

    let enrollmentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: Const.plus),
                        for: .normal)
        button.backgroundColor = .systemGray4

        return button
    }()

    let imageAndPickerButtonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var imageAndPickerButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageStackView,
                                                       enrollmentButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Const.ten
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()

    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Const.ten
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameTextField,
                                                       productPriceStackView,
                                                       discountedPriceTextField,
                                                       productStockTextField])
        stackView.spacing = Const.ten
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var productPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [originalPriceTextField,
                                                       currencySegmentedControl])
        stackView.spacing = Const.ten
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()

    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = Const.productName
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textField
    }()

    let originalPriceTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = Const.productPrice
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textField
    }()

    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            Currency.krw.rawValue,
            Currency.usd.rawValue])
        segmentedControl.selectedSegmentIndex = Const.zero
        return segmentedControl
    }()

    let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = Const.productDiscountedPrice
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textField
    }()

    let productStockTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = Const.productStock
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textField
    }()

    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textView
    }()

    private let pagePurpose: PagePurpose

    init(pagePurpose: PagePurpose) {
        self.pagePurpose = pagePurpose
        super.init(frame: .zero)
        
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)
        imageAndPickerButtonScrollView.addSubview(imageAndPickerButtonStackView)
        productDescriptionTextView.delegate = self

        let heightAnchor = rootScrollView.heightAnchor.constraint(equalTo: rootScrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true

        configureLayouts()
        registerNotificationForKeyboard()
        hideEnrollmentButton()
    }

    private func hideEnrollmentButton() {
        switch pagePurpose {
        case .enrollment:
            enrollmentButton.isHidden = false
        case .modification:
            enrollmentButton.isHidden = true
        }
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
            rootStackView.widthAnchor.constraint(equalTo: rootScrollView.widthAnchor),
        ])

        NSLayoutConstraint.activate([
            imageAndPickerButtonStackView.topAnchor.constraint(equalTo: imageAndPickerButtonScrollView.topAnchor),
            imageAndPickerButtonStackView.bottomAnchor.constraint(equalTo: imageAndPickerButtonScrollView.bottomAnchor),
            imageAndPickerButtonStackView.trailingAnchor.constraint(equalTo: imageAndPickerButtonScrollView.trailingAnchor),
            imageAndPickerButtonStackView.leadingAnchor.constraint(equalTo: imageAndPickerButtonScrollView.leadingAnchor),

            imageAndPickerButtonStackView.heightAnchor.constraint(equalTo: imageAndPickerButtonScrollView.heightAnchor),
            productDescriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            enrollmentButton.widthAnchor.constraint(equalTo: enrollmentButton.heightAnchor)
        ])
    }

    private func registerNotificationForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    private func checkNumberOfTextValidation(_ text: String?, by limitedNumber: Int) -> Bool {
        guard let count = text?.count,
              count >= limitedNumber else {
            return false
        }
        return true
    }

    func convertTextToTypeDTO() -> TypedProductDetailsRequestDTO {
        let currency = currencySegmentedControl.selectedSegmentIndex == 0 ? Currency.krw : Currency.usd
        let data = TypedProductDetailsRequestDTO(name: productNameTextField.text ?? "",
                                                 description: productDescriptionTextView.text,
                                                 price: originalPriceTextField.text?.convertToDouble() ?? Const.zeroPointZero,
                                                 currency: currency.rawValue,
                                                 discountedPrice: discountedPriceTextField.text?.convertToDouble(),
                                                 stock: productStockTextField.text?.convertToInt(),
                                                 secret: User.secret)
        return data
    }

    func addSquareImageView(_ view: UIView) {
        imageStackView.addArrangedSubview(view)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let contentInset = UIEdgeInsets(
            top: Const.zeroPointZero,
            left: Const.zeroPointZero,
            bottom: keyboardFrame.size.height,
            right: Const.zeroPointZero)

        rootScrollView.contentInset = contentInset
        rootScrollView.scrollIndicatorInsets = contentInset
    }

    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        rootScrollView.contentInset = contentInset
        rootScrollView.scrollIndicatorInsets = contentInset
    }

    enum Const {
        static let zero = 0
        static let zeroPointZero: CGFloat = 0.0
        static let two = 2
        static let ten: CGFloat = 10
        static let oneThousand = 1000
        static let plus = "plus"
        static let productName = "상품명"
        static let productPrice = "상품 가격"
        static let productDiscountedPrice = "할인금액"
        static let productStock = "재고 수량"
        static let productDescription = "상품설명"
    }
}

// MARK: - UITextViewDelegate

extension ProductEnrollmentView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard checkNumberOfTextValidation(textView.text, by: Const.oneThousand) else {
            //                self?.presentConfirmAlert(message: AlertMessage.exceedValue)
            return true
        }
        return false
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == Const.productDescription else { return }

        textView.text = nil
        textView.textColor = .black
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        textView.text = Const.productDescription
        textView.textColor = .lightGray
    }
}
