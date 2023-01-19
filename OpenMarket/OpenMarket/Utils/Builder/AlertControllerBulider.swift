//
//  AlertControllerBulider.swift
//  OpenMarket
//
//  Created by 데릭.
//

import UIKit

struct AlertControllerBulider {
    private var params:BuilderParams

    init(params:BuilderParams) {
        self.params = params
    }

    @MainActor
    func present() {
        let alertController = UIAlertController(title: self.params.title,
                                                message: self.params.message,
                                                preferredStyle: UIAlertController.Style.alert)
        if (self.params.confirmText) != nil {
            alertController.addAction(UIAlertAction(title: self.params.confirmText,
                                                    style: UIAlertAction.Style.destructive,
                                                    handler: self.params.confirmAction))
        }

        if (self.params.cancelText) != nil {
            alertController.addAction(UIAlertAction(title: self.params.cancelText,
                                                    style: UIAlertAction.Style.destructive,
                                                    handler: self.params.cancelAction))
        }

        self.params.context.present(alertController, animated: true, completion: nil)
    }

    struct BuilderParams {
        var context:UIViewController
        var title:String?
        var message:String?
        var confirmText:String?
        var cancelText:String?

        var confirmAction:((UIAlertAction)->Void)?

        var cancelAction:((UIAlertAction)->Void)?

        init(_ context:UIViewController) {
            self.context = context
        }
    }

    class Builder {
        private var params:BuilderParams
        init(_ context: UIViewController) {
            self.params = BuilderParams.init(context)
        }

        func setTitle(_ title:String) -> Builder {
            self.params.title = title
            return self
        }

        func setMessag(_ message:String) -> Builder {
            self.params.message = message
            return self
        }

        func setConfrimText(_ confirmText:String) -> Builder {
            self.params.confirmText = confirmText
            return self
        }

        func setCancelText(_ cancelText:String) -> Builder {
            self.params.cancelText = cancelText
            return self
        }

        func setConfirmAction(_ confirmAction:@escaping ((UIAlertAction)->Void)) -> Builder {
            self.params.confirmAction = confirmAction
            return self
        }

        func setCancelAction(_ cancelAction:@escaping ((UIAlertAction)->Void)) -> Builder {
            self.params.cancelAction = cancelAction
            return self
        }

        func build() -> AlertControllerBulider {
            return AlertControllerBulider(params: self.params)
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
