//
//  RoundedView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 19..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     라운드 뷰
 */
@IBDesignable class RoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.1 {
        didSet {
            updateCornerRadius()
        }
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = rounded ? cornerRadius : 0
        layer.masksToBounds = rounded ? true : false
    }
}
