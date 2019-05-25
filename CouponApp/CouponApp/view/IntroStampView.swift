//
//  IntroTitleView.swift
//  CouponApp
//
//  Created by kim sunchul on 11/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

typealias InstroStampCallBack = () -> Void

class IntroStampView: UIView, CAAnimationDelegate{
    var drawLayer:CAShapeLayer = CAShapeLayer()
    var completion:InstroStampCallBack?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }
    
    override func draw(_ rect: CGRect) {
        let rateX:CGFloat = 0.4
        let rateY:CGFloat = 0.4
        
        
        let adjHorzPos:CGFloat = 0 * rateX; //391
        let adjVertPos:CGFloat = 445 * rateY; //445
        
        let drawing = UIBezierPath()
        drawing.move(to: CGPoint(x: (252 * rateX) + adjHorzPos, y:( -268 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (234 * rateX) + adjHorzPos, y: (-213 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (252 * rateX) + adjHorzPos, y: (-268 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (233 * rateX) + adjHorzPos, y: (-240 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (252 * rateX) + adjHorzPos, y: (-145 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (233 * rateX) + adjHorzPos, y: (-194 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (236 * rateX) + adjHorzPos, y: (-163 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (287 * rateX) + adjHorzPos, y: (-124 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (268 * rateX) + adjHorzPos, y: (-128 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (287 * rateX) + adjHorzPos, y: (-124 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (370 * rateX) + adjHorzPos, y: (-124 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (287 * rateX) + adjHorzPos, y: (-124 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (370 * rateX) + adjHorzPos, y: (-124 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (391 * rateX) + adjHorzPos, y: (-97 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (370 * rateX) + adjHorzPos, y: (-124 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (389 * rateX) + adjHorzPos, y: (-122 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (391 * rateX) + adjHorzPos, y: (-61 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (393 * rateX) + adjHorzPos, y: (-73 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (391 * rateX) + adjHorzPos, y: (-61 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (351 * rateX) + adjHorzPos, y: (-42 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (391 * rateX) + adjHorzPos, y: (-61 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (386 * rateX) + adjHorzPos, y: (-41 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (272 * rateX) + adjHorzPos, y: (-42 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (301 * rateX) + adjHorzPos, y: (-42 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (272 * rateX) + adjHorzPos, y: (-42 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (26 * rateX) + adjHorzPos, y: (-42 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (272 * rateX) + adjHorzPos, y: (-42 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (26 * rateX) + adjHorzPos, y: (-42 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (2 * rateX) + adjHorzPos, y: (-65 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (26 * rateX) + adjHorzPos, y: (-42 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (7 * rateX) + adjHorzPos, y: (-41 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (27 * rateX) + adjHorzPos, y: (-124 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (-2 * rateX) + adjHorzPos, y: (-90 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (1 * rateX) + adjHorzPos, y: (-120 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (94 * rateX) + adjHorzPos, y: (-125 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (53 * rateX) + adjHorzPos, y: (-129 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (94 * rateX) + adjHorzPos, y: (-125 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (144 * rateX) + adjHorzPos, y: (-155 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (94 * rateX) + adjHorzPos, y: (-125 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (127 * rateX) + adjHorzPos, y: (-128 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (157 * rateX) + adjHorzPos, y: (-213 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (160 * rateX) + adjHorzPos, y: (-181 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (157 * rateX) + adjHorzPos, y: (-213 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (140 * rateX) + adjHorzPos, y: (-264 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (157 * rateX) + adjHorzPos, y: (-213 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (154 * rateX) + adjHorzPos, y: (-243 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (114 * rateX) + adjHorzPos, y: (-333 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (126 * rateX) + adjHorzPos, y: (-284 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (115 * rateX) + adjHorzPos, y: (-320 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (139 * rateX) + adjHorzPos, y: (-417 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (113 * rateX) + adjHorzPos, y: (-346 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (121 * rateX) + adjHorzPos, y: (-397 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (196 * rateX) + adjHorzPos, y: (-445 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (161 * rateX) + adjHorzPos, y: (-439 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (167 * rateX) + adjHorzPos, y: (-442 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (265 * rateX) + adjHorzPos, y: (-399 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (225 * rateX) + adjHorzPos, y: (-449 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (254 * rateX) + adjHorzPos, y: (-419 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (278 * rateX) + adjHorzPos, y: (-321 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (276 * rateX) + adjHorzPos, y: (-379 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (283 * rateX) + adjHorzPos, y: (-353 * rateY) + adjVertPos))
        drawing.close()

        drawing.move(to: CGPoint(x: (379 * rateX) + adjHorzPos, y:( -32 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (12 * rateX) + adjHorzPos, y: (-32 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (379 * rateX) + adjHorzPos, y: (-32 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (12 * rateX) + adjHorzPos, y: (-32 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (1 * rateX) + adjHorzPos, y: (-14 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (12 * rateX) + adjHorzPos, y: (-32 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (1 * rateX) + adjHorzPos, y: (-30 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (22 * rateX) + adjHorzPos, y: (-1 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (0 * rateX) + adjHorzPos, y: (1 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (22 * rateX) + adjHorzPos, y: (-1 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (379 * rateX) + adjHorzPos, y: (-1 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (22 * rateX) + adjHorzPos, y: (-1 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (379 * rateX) + adjHorzPos, y: (-1 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (392 * rateX) + adjHorzPos, y: (-16 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (379 * rateX) + adjHorzPos, y: (-1 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (391 * rateX) + adjHorzPos, y: (-3 * rateY) + adjVertPos))
        
        drawing.close()
        
        drawLayer.path = drawing.cgPath
        drawLayer.strokeEnd = 1
        drawLayer.lineWidth = 1
        drawLayer.strokeColor = UIColor.white.cgColor
        drawLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(drawLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.delegate = self
        drawLayer.add(animation, forKey: "line")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (flag) {
            guard let callback = completion else {
                return
            }
            callback()
        }
    }
    
}
