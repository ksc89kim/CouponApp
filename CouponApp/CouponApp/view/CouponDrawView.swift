//
//  CouponView.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 8. 15..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

/*
 쿠폰 그리기 뷰
 - Draw를 통해 쿠폰을 그림, 원형 형태의 쿠폰.
 */
class CouponDrawView: UIView, CouponView{
    var uiData: CouponUI?{
        didSet {
            updateUI()
        }
    }
    
    let backgroundCircleLayer:CAShapeLayer = CAShapeLayer()
    let ringThicknessLayer:CAShapeLayer = CAShapeLayer()
    let checkLayer:CAShapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
    
    func getBackgroundCirclePath(_ rect: CGRect) -> CGPath {
        return UIBezierPath(ovalIn: rect).cgPath
    }
    
    func getRingThicknessPath(_ rect: CGRect, _ hw:CGFloat) -> CGPath {
        return UIBezierPath(ovalIn: rect.insetBy(dx: hw,dy: hw)).cgPath
    }
    
    func getCheckPath(_ rect: CGRect) -> CGPath {
        var start:CGPoint = CGPoint(x: rect.maxX * 0.25, y: rect.maxY * 0.45)
        var end:CGPoint = CGPoint(x: rect.maxX * 0.5, y: rect.maxY * 0.65)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        start = CGPoint(x: end.x, y: end.y)
        end = CGPoint(x: rect.maxX * 0.75, y: rect.maxY * 0.35)
        
        path.move(to: start)
        path.addLine(to: end)
        
        return path.cgPath
    }
    
    func getCheckAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        return animation
    }
    
    override func draw(_ rect: CGRect) {
        drawBackgroundCircle(rect)
        drawRingThickness(rect)
        drawCheck(rect)
    }
    
    func drawBackgroundCircle(_ rect: CGRect) {
        guard let drawCoupon = uiData as? DrawCoupon else { return }
        
        backgroundCircleLayer.removeFromSuperlayer()
        backgroundCircleLayer.path = getBackgroundCirclePath(rect)
        backgroundCircleLayer.fillColor = UIColor.hexStringToUIColor(hex: drawCoupon.circleColor).cgColor
        layer.addSublayer(backgroundCircleLayer)
    }
    
    func drawRingThickness(_ rect: CGRect) {
        guard let drawCoupon = uiData as? DrawCoupon else { return }
        guard drawCoupon.isRing else { ringThicknessLayer.removeFromSuperlayer(); return }
        
        ringThicknessLayer.path = getRingThicknessPath(rect, drawCoupon.ringThickness/2)
        ringThicknessLayer.fillColor = UIColor.clear.cgColor
        ringThicknessLayer.strokeColor = UIColor.hexStringToUIColor(hex: drawCoupon.ringColor).cgColor
        ringThicknessLayer.lineWidth = drawCoupon.ringThickness
        layer.addSublayer(ringThicknessLayer)
    }
    
    func drawCheck(_ rect:CGRect) {
        guard let drawCoupon = uiData as? DrawCoupon else { return }
        guard drawCoupon.isUseCoupon else { checkLayer.removeFromSuperlayer(); return }
        
        checkLayer.path = getCheckPath(rect)
        checkLayer.strokeColor = UIColor.hexStringToUIColor(hex: drawCoupon.checkLineColor).cgColor
        checkLayer.lineWidth = drawCoupon.checkLineWidth
        checkLayer.lineCap = "round"
        
        if drawCoupon.isAnimation{
            checkLayer.add(getCheckAnimation(), forKey: "line")
            drawCoupon.isAnimation = false
        }
        
        layer.addSublayer(checkLayer)
    }
    
    
}
