//
//  Utils.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 5. 13..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class Utils {
    
    // MARK: - 키보드에 따른 뷰 높이 계산
    static func setUpViewHeight (_ view:UIView, _ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let keyboardMaxY = (view.frame.origin.y + view.frame.height) - keyboardHeight
            let firstResponder = findFirstResponder(inView: view)
            let globalFrame = firstResponder?.superview?.convert((firstResponder?.frame)!, to: nil)
            let textFieldMaxY = ceil((globalFrame?.origin.y)! + (globalFrame?.size.height)! + 15)
            let frameY = keyboardMaxY - textFieldMaxY
            if frameY < 1 {
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
            if let recursiveSubView = Utils.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }
}
