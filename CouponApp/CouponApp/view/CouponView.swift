//
//  CouponView.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 8. 15..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

// 쿠폰 이미지

@IBDesignable
class CouponView: UIView {
    
    @IBInspectable var circleColor: UIColor = UIColor.blue // 원 색상
    @IBInspectable var ringColor: UIColor = UIColor.orange // 테두리 색상
    @IBInspectable var ringThickness: CGFloat = 4 // 테두리 굵기
    @IBInspectable var isRing: Bool = true // 테두리 여부
    @IBInspectable var isUseCoupone: Bool = true // 쿠폰 체크박스 여부
    @IBInspectable var checkLineWidth: CGFloat = 4 // 쿠폰 체크박스 굵기
    @IBInspectable var checkLineColor: UIColor = UIColor.orange // 쿠폰 체크 박스 색상
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        let dotPath = UIBezierPath(ovalIn: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = circleColor.cgColor
        layer.addSublayer(shapeLayer)
                
        if (isRing) { drawRingFittingInsideView(rect) }
        if (isUseCoupone) { drawCheckFittingInsideView(rect) }
    }
    
    // 링 그리기
    func drawRingFittingInsideView(_ rect: CGRect) {
        let hw:CGFloat = ringThickness/2
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw,dy: hw) )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = ringColor.cgColor
        shapeLayer.lineWidth = ringThickness
        layer.addSublayer(shapeLayer)
    }
    
    // 체크박스 그리기
    func drawCheckFittingInsideView(_ rect:CGRect) {
        
        let radius = rect.maxX/2
        let startCircleInPoint:CGPoint = CGPoint(x: rect.maxX/4, y: rect.maxY/4)
        let endCircleInPoint:CGPoint = CGPoint(x:startCircleInPoint.x + radius,y:startCircleInPoint.y + radius)
        
        var start:CGPoint = CGPoint(x: startCircleInPoint.x, y: startCircleInPoint.y)
        var end:CGPoint = CGPoint(x: startCircleInPoint.x+(radius/2), y: endCircleInPoint.y)
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        start.x = startCircleInPoint.x+(radius/2)
        start.y = endCircleInPoint.y
        end.x = endCircleInPoint.x
        end.y = startCircleInPoint.y
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = checkLineColor.cgColor
        shapeLayer.lineWidth = checkLineWidth
        layer.addSublayer(shapeLayer)
    }
    

}