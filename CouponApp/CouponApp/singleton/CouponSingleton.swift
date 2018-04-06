//
//  CouponSingleton.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     쿠폰 전체앱 싱글톤 클래스
 */
class CouponSignleton {
    static let sharedInstance = CouponSignleton()
    var networkData:NetworkModel? = NetworkModel()
    var userData:UserModel? = UserModel()
    var merchantList:[MerchantModel?]? //가맹점 리스트
    
    
    // MARK: - 가맹점 데이터 찾기
    func findMerchantModel(merchantId:Int?) -> MerchantModel? {
        var fMerchantModel:MerchantModel? = nil;
        for merchantModel in merchantList! {
            if merchantModel?.merchantId == merchantId {
                fMerchantModel = merchantModel
                break;
            }
        }
        return fMerchantModel
    }
    
    
     // MARK: - 경고 팝업창
    static func showAlert(viewController:UIViewController,title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - 커스텀 팝업창
    static func showCustomPopup(title:String, message:String, callback:(() -> Void)?){
        let customPopup = CustomPopupView()
        customPopup.okCallback = callback
        customPopup.title.text = title
        customPopup.content.text = message
        let window = UIApplication.shared.keyWindow!
        customPopup.frame = window.frame
        window.addSubview(customPopup)
    }
    
    // MARK: - 키보드에 따른 뷰 높이 계산
    static func setUpViewHeight (_ view:UIView, _ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let keyboardMaxY = view.frame.height - keyboardHeight
            let firstResponder = findFirstResponder(inView: view)
            let globalFrame = firstResponder?.superview?.convert((firstResponder?.frame)!, to: nil)
            let textFieldMaxY = ceil((globalFrame?.origin.y)! + (globalFrame?.size.height)! + 15)
            let frameY = keyboardMaxY - textFieldMaxY
            if frameY > 0 {
                view.frame.origin.y = 0
            } else {
                view.frame.origin.y = frameY
            }
        }
    }
    
    // MARK: - 이벤트 리스폰더 응답 첫번째 객체
    static func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }
            if let recursiveSubView = CouponSignleton.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }
}
