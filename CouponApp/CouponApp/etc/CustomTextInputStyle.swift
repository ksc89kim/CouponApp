//
//  CustomTextInputStyle.swift
//  CouponApp
//
//  Created by kim sunchul on 27/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import Foundation
import AnimatedTextInput

struct CustomTextInputStyle: AnimatedTextInputStyle {
    let placeholderInactiveColor = UIColor.gray
    let activeColor = UIColor.hexStringToUIColor(hex: "#F84C4E")
    let inactiveColor = UIColor.gray.withAlphaComponent(0.3)
    let lineInactiveColor = UIColor.gray.withAlphaComponent(0.3)
    let lineActiveColor = UIColor.hexStringToUIColor(hex: "#F84C4E")
    let lineHeight: CGFloat = 1
    let errorColor = UIColor.red
    let textInputFont = UIFont(name: "NotoSansCJKkr-Ragular", size: 14) ?? UIFont.systemFont(ofSize: 14)
    let textInputFontColor = UIColor.black
    let placeholderMinFontSize: CGFloat = 9
    let counterLabelFont: UIFont? = UIFont(name: "NotoSansCJKkr-Ragular", size: 9) ?? UIFont.systemFont(ofSize: 9)
    let leftMargin: CGFloat = 0
    let topMargin: CGFloat = 20
    let rightMargin: CGFloat = 0
    let bottomMargin: CGFloat = 10
    let yHintPositionOffset: CGFloat = 7
    let yPlaceholderPositionOffset: CGFloat = 0
    public let textAttributes: [String: Any]? = nil
}
