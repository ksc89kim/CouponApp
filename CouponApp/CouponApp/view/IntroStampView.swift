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
    private var drawLayer:CAShapeLayer = CAShapeLayer()
    var completion:InstroStampCallBack?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }
    
    override func draw(_ rect: CGRect) {
        let originalWidth:CGFloat = 160.08163265306
        let originalHeight:CGFloat = 169.222222222223
        
        let rateX:CGFloat = rect.size.width/originalWidth;
        let rateY:CGFloat = rect.size.height/originalHeight;
        let adjHorzPos:CGFloat = 0
        let adjVertPos:CGFloat = 0
        
        let drawing = UIBezierPath()
        drawing.move(to: CGPoint(x: (53 * rateX) + adjHorzPos, y:( 18 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (70 * rateX) + adjHorzPos, y: (3 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (53 * rateX) + adjHorzPos, y: (18 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (59 * rateX) + adjHorzPos, y: (7 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (94 * rateX) + adjHorzPos, y: (3 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (70 * rateX) + adjHorzPos, y: (3 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (78 * rateX) + adjHorzPos, y: (-2 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (115 * rateX) + adjHorzPos, y: (37 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (94 * rateX) + adjHorzPos, y: (3 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (114 * rateX) + adjHorzPos, y: (11 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (103 * rateX) + adjHorzPos, y: (66 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (115 * rateX) + adjHorzPos, y: (37 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (117 * rateX) + adjHorzPos, y: (51 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (97 * rateX) + adjHorzPos, y: (92 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (103 * rateX) + adjHorzPos, y: (66 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (96 * rateX) + adjHorzPos, y: (76 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (106 * rateX) + adjHorzPos, y: (109 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (97 * rateX) + adjHorzPos, y: (92 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (96 * rateX) + adjHorzPos, y: (102 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (118 * rateX) + adjHorzPos, y: (115 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (106 * rateX) + adjHorzPos, y: (109 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (113 * rateX) + adjHorzPos, y: (115 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (152 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (118 * rateX) + adjHorzPos, y: (115 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (152 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (161 * rateX) + adjHorzPos, y: (124 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (152 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (158 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (161 * rateX) + adjHorzPos, y: (135 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (161 * rateX) + adjHorzPos, y: (124 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (161 * rateX) + adjHorzPos, y: (135 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (151 * rateX) + adjHorzPos, y: (146 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (161 * rateX) + adjHorzPos, y: (135 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (162 * rateX) + adjHorzPos, y: (143 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (10 * rateX) + adjHorzPos, y: (145 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (151 * rateX) + adjHorzPos, y: (146 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (10 * rateX) + adjHorzPos, y: (145 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (2 * rateX) + adjHorzPos, y: (138 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (10 * rateX) + adjHorzPos, y: (145 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (5 * rateX) + adjHorzPos, y: (144 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (1 * rateX) + adjHorzPos, y: (125 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (2 * rateX) + adjHorzPos, y: (138 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (1 * rateX) + adjHorzPos, y: (125 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (11 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (1 * rateX) + adjHorzPos, y: (125 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (3 * rateX) + adjHorzPos, y: (117 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (39 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (11 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (39 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (60 * rateX) + adjHorzPos, y: (103 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (39 * rateX) + adjHorzPos, y: (116 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (55 * rateX) + adjHorzPos, y: (111 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (63 * rateX) + adjHorzPos, y: (80 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (60 * rateX) + adjHorzPos, y: (103 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (67 * rateX) + adjHorzPos, y: (94 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (50 * rateX) + adjHorzPos, y: (54 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (63 * rateX) + adjHorzPos, y: (80 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (57 * rateX) + adjHorzPos, y: (63 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (47 * rateX) + adjHorzPos, y: (32 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (50 * rateX) + adjHorzPos, y: (54 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (45 * rateX) + adjHorzPos, y: (42 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (53 * rateX) + adjHorzPos, y: (18 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (48 * rateX) + adjHorzPos, y: (24 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (53 * rateX) + adjHorzPos, y: (18 * rateY) + adjVertPos))

        drawing.move(to: CGPoint(x: (88 * rateX) + adjHorzPos, y:( 149 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (156 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (88 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (156 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (161 * rateX) + adjHorzPos, y: (154 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (156 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (161 * rateX) + adjHorzPos, y: (150 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (157 * rateX) + adjHorzPos, y: (160 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (161 * rateX) + adjHorzPos, y: (154 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (162 * rateX) + adjHorzPos, y: (158 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (6 * rateX) + adjHorzPos, y: (160 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (157 * rateX) + adjHorzPos, y: (160 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (6 * rateX) + adjHorzPos, y: (160 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (1 * rateX) + adjHorzPos, y: (154 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (6 * rateX) + adjHorzPos, y: (160 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (1 * rateX) + adjHorzPos, y: (160 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (6 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (1 * rateX) + adjHorzPos, y: (154 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (1 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos))
        drawing.addCurve(to: CGPoint(x: (88 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos), controlPoint1: CGPoint(x: (88 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos), controlPoint2: CGPoint(x: (88 * rateX) + adjHorzPos, y: (149 * rateY) + adjVertPos))
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
