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
class CouponDrawView: UIView {
    var drawCoupon:DrawCoupon? {
        didSet {
            if drawCoupon != nil {
                setNeedsDisplay()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        guard drawCoupon != nil else { return }
        
        let dotPath = UIBezierPath(ovalIn: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = UIColor.hexStringToUIColor(hex: (drawCoupon?.circleColor)!).cgColor
        layer.addSublayer(shapeLayer)
    
        if (drawCoupon?.isRing)! { drawRingFittingInsideView(rect) }
        if (drawCoupon?.isUseCoupon)! { drawCheckFittingInsideView(rect) }
    }
    
    // 링 그리기
    func drawRingFittingInsideView(_ rect: CGRect) {
        let hw:CGFloat = (drawCoupon?.ringThickness)!/2
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw,dy: hw) )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.hexStringToUIColor(hex: (drawCoupon?.ringColor)!).cgColor
        shapeLayer.lineWidth = (drawCoupon?.ringThickness)!
        layer.addSublayer(shapeLayer)
    }
    
    // 체크박스 그리기
    func drawCheckFittingInsideView(_ rect:CGRect) {
        var start:CGPoint = CGPoint(x: rect.maxX * 0.25, y: rect.maxY * 0.45)
        var end:CGPoint = CGPoint(x: rect.maxX * 0.5, y: rect.maxY * 0.65)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        start = CGPoint(x: end.x, y: end.y)
        end = CGPoint(x: rect.maxX * 0.75, y: rect.maxY * 0.35)
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.hexStringToUIColor(hex: (drawCoupon?.checkLineColor)!).cgColor
        shapeLayer.lineWidth = (drawCoupon?.checkLineWidth)!
        shapeLayer.lineCap = "round"
        
        if (drawCoupon?.isAnimation)! {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.3
            shapeLayer.add(animation, forKey: "line")
            drawCoupon?.isAnimation = false
        }
        
        layer.addSublayer(shapeLayer)
    }
    

}
