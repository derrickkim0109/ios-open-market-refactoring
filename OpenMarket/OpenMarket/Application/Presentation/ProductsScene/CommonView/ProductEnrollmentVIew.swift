//
//  ProductEnrollmentVIew.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

import UIKit

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
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10,
                                               left: 10,
                                               bottom: 10,
                                               right: 10)
        return stackView
    }()

    let imageAndPickerButtonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var imageAndPickerButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()



    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
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
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var productPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [originalPriceTextField,
                                                       currencySegmentedControl])
        stackView.spacing = 10
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
        textField.placeholder = ProductStatus.productName
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textField
    }()

    let originalPriceTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = ProductStatus.productPrice
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textField
    }()

    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            Currency.krw.rawValue,
            Currency.usd.rawValue])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = ProductStatus.discountedPrice
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textField
    }()

    let productStockTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = ProductStatus.numberOfStocks
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textField
    }()

    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        return textView
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)
        imageAndPickerButtonScrollView.addSubview(imageAndPickerButtonStackView)

        let heightAnchor = rootScrollView.heightAnchor.constraint(equalTo: rootScrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true

        configureLayouts()
        connectDelegate()
        registerNotificationForKeyboard()
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
            imageAndPickerButtonStackView.heightAnchor.constraint(equalTo: imageAndPickerButtonScrollView.heightAnchor)
        ])
    }

    private func connectDelegate() {
        productNameTextField.delegate = self
        originalPriceTextField.delegate = self
        discountedPriceTextField.delegate = self
        productStockTextField.delegate = self
        productDescriptionTextView.delegate = self
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

    private func checkNumberOfNameText(_ productNameText: String) {
        //        switch productNameText.count {
        //        case 0:
        //            DispatchQueue.main.async { [weak self] in
        ////                self?.presentConfirmAlert(message: AlertMessage.emptyValue)
        //            }
        //        case 1..<3:
        //            DispatchQueue.main.async { [weak self] in
        ////                self?.presentConfirmAlert(message: AlertMessage.additionalCharacters)
        //            }
        //        default:
        //            break
        //        }
    }

    private func limitTextLength(_ text: String?) -> Bool {
        let textFields = [productNameTextField,
                          originalPriceTextField,
                          discountedPriceTextField,
                          productStockTextField]

//        for field in textFields {
//            if field == productNameTextField {
//                return checkNumberOfTextValidation(text, by: 40)
//            } else {
//                return checkNumberOfTextValidation(text, by: 10)
//            }
//        }
        return true
    }

    func convertTextToTypeDTO() -> TypedProductDetailsRequestDTO {
        let currency = currencySegmentedControl.selectedSegmentIndex == 0 ? Currency.krw : Currency.usd
        let data = TypedProductDetailsRequestDTO(name: productNameTextField.text,
                                                 descriptions: productDescriptionTextView.text,
                                                 price: originalPriceTextField.text?.convertToDouble(),
                                                 currency: currency,
                                                 discountedPrice: discountedPriceTextField.text?.convertToDouble(),
                                                 stock: productStockTextField.text?.convertToInt(),
                                                 secret: User.secret)
        return data
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)

        rootScrollView.contentInset = contentInset
        rootScrollView.scrollIndicatorInsets = contentInset
    }

    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        rootScrollView.contentInset = contentInset
        rootScrollView.scrollIndicatorInsets = contentInset
    }
}

// MARK: - UITextFieldDelegate

extension ProductEnrollmentView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        return limitTextLength(textField.text)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField {
        case productNameTextField:
            guard let productNameText =
                    productNameTextField.text?.replacingOccurrences(of: " ",
                                                                    with: "") else { return }
            checkNumberOfNameText(productNameText)
        case originalPriceTextField:
            guard checkNumberOfTextValidation(originalPriceTextField.text, by: 0) else { return }
            //                self?.presentConfirmAlert(message: AlertMessage.emptyValue)
        default:
            break
        }
    }
}

// MARK: - UITextViewDelegate

extension ProductEnrollmentView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard checkNumberOfTextValidation(textView.text, by: 1000) else {
            //                self?.presentConfirmAlert(message: AlertMessage.exceedValue)
            return true
        }
        return false
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == ProductStatus.productDescription else { return }

        textView.text = nil
        textView.textColor = .black
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        textView.text = ProductStatus.productDescription
        textView.textColor = .lightGray
    }
}
