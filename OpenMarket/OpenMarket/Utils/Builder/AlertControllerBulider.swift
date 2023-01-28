//
//  AlertControllerBulider.swift
//  OpenMarket
//
//  Created by 데릭.
//

import UIKit

struct AlertControllerBulider {
    private let params: BuilderParams

    init(params: BuilderParams) {
        self.params = params
    }

    @MainActor
    func present() async {
        let alertController = UIAlertController(
            title: params.title,
            message: params.message,
            preferredStyle: params.style)

        alertController.addAction(
            UIAlertAction(title: params.confirmText,
                          style: .default,
                          handler: params.confirmAction))

        if params.destructiveStyleCancelText != nil {
            alertController.addAction(
                UIAlertAction(title: params.destructiveStyleCancelText,
                              style: .destructive,
                              handler: params.destructiveStyleCancelAction))
        }

        if params.cancelStyleCancelText != nil {
            alertController.addAction(
                UIAlertAction(title: params.cancelStyleCancelText,
                              style: .cancel,
                              handler: params.cancelStyleCancelAction))
        }

        params.context?.present(
            alertController,
            animated: true,
            completion: nil)
    }

    struct BuilderParams {
        private let firstScene =
        UIApplication.shared.connectedScenes.compactMap{ $0 as? UIWindowScene }.first

        var context: UIViewController?
        var style: UIAlertController.Style = .alert
        var title: String?
        var message: String?
        var confirmText: String? = "확인"
        var destructiveStyleCancelText: String?
        var cancelStyleCancelText: String?

        var confirmAction: ((UIAlertAction) -> Void)?
        var destructiveStyleCancelAction: ((UIAlertAction) -> Void)?
        var cancelStyleCancelAction: ((UIAlertAction) -> Void)?

        init() {
            let rootViewController =
            firstScene?.windows.filter{ $0.isKeyWindow }.first?.rootViewController

            context = rootViewController
        }
    }

    class Builder {
        private var params:BuilderParams
        
        init() {
            params = BuilderParams()
        }

        func setAlertStyle(
            _ style: UIAlertController.Style) -> Builder {
            params.style = style
            return self
        }

        func setTitle(
            _ title: String?) -> Builder {
            params.title = title
            return self
        }

        func setMessag(
            _ message: String) -> Builder {
            params.message = message
            return self
        }

        func setConfrimText(
            _ confirmText: String?) -> Builder {
            params.confirmText = confirmText
            return self
        }

        func setDestructiveStyleCancelText(
            _ cancelText: String?) -> Builder {
            params.destructiveStyleCancelText = cancelText
            return self
        }

        func setCancelStyleCancelText(
            _ cancelText: String?) -> Builder {
            params.cancelStyleCancelText = cancelText
            return self
        }

        func setConfirmAction(
            _ confirmAction: @escaping ((UIAlertAction) -> Void)) -> Builder {
            params.confirmAction = confirmAction
            return self
        }

        func setDestructiveStyleCancelAction(
            _ destructiveStyleCancelAction: @escaping ((UIAlertAction) -> Void)) -> Builder {
            params.destructiveStyleCancelAction = destructiveStyleCancelAction
            return self
        }

        func setCancelStyleCancelAction(
            _ cancelStyleCancelAction: @escaping ((UIAlertAction) -> Void)) -> Builder {
            params.cancelStyleCancelAction = cancelStyleCancelAction
            return self
        }

        func build() -> AlertControllerBulider {
            return AlertControllerBulider(
                params: params)
        }
    }
}

enum AlertMessage {
    static let enrollmentSuccess = "상품 등록하였습니다"
    static let enrollmentFailure = "상품 등록 실패하였습니다"
    static let modificationSuccess = "상품 수정 완료하였습니다"
    static let modificationFailure = "상품 수정 실패하였습니다"
    static let deleteSuccess = "상품 삭제 완료하였습니다"
    static let deleteFailure = "상품 삭제 실패하였습니다"
    static let additionalCharacters = "상품명은 세 글자 이상 입력되어야 합니다"
    static let emptyValue = "값이 없습니다"
    static let exceedValue = "글자수가 초과되었습니다"
    static let exceedImages = "이미지를 추가할 수 없습니다"
    static let missMatchIdentifier = "상품 등록 아이디가 아닙니다"
    static let confirm = "확인되었습니다"
    static let inputPassword = "암호를 입력해주세요"
}
