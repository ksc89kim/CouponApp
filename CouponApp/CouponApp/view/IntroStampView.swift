//
//  IntroTitleView.swift
//  CouponApp
//
//  Created by kim sunchul on 11/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

typealias InstroStampCallBack = () -> Void

final class IntroStampView: UIView, CAAnimationDelegate{
    private var drawLayer:CAShapeLayer = CAShapeLayer()
    private var introPath:IntroStampDrawPath =
        IntroStampDrawPath(
            drawRect:CGRect(origin:CGPoint.zero, size:CGSize(width: 160.08163265306, height: 169.222222222223)),
            parentRect:CGRect.zero)
    
    var completion:InstroStampCallBack?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addSublayer(drawLayer)
        //custom logic goes here
    }
    
    override func draw(_ rect: CGRect) {
        introPath.setRate(parentRect: rect)
        introPath.draw()
        setDrawLayer()
        drawLayer.add(getStrokeAnimation(), forKey: "line")
    }
    
    private func setDrawLayer() {
        drawLayer.path = introPath.getCGPath()
        drawLayer.strokeEnd = 1
        drawLayer.lineWidth = 1
        drawLayer.strokeColor = UIColor.white.cgColor
        drawLayer.fillColor = UIColor.clear.cgColor
    }
    
    private func getStrokeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.delegate = self
        return animation
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
