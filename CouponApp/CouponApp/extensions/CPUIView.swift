//
//  CPUIView.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 2. 3..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

extension UIView {

    func addDashedBorder(color:UIColor, lineWidth:CGFloat) {
        self.layoutIfNeeded()
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = [2,3]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }

}
