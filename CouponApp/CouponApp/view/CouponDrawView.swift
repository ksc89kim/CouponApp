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
class CouponDrawView: CouponView {
    var model:DrawCouponModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        model = DrawCouponModel()
        //custom logic goes here
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        guard !isImageCoupon else { return }
        guard model != nil else { return }
        
        // Drawing code
        let dotPath = UIBezierPath(ovalIn: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = UIColor.hexStringToUIColor(hex: (model?.circleColor)!).cgColor
        layer.addSublayer(shapeLayer)
        
        if (model?.isRing)! { drawRingFittingInsideView(rect) }
        if (isUseCoupone) { drawCheckFittingInsideView(rect) }
    }
    
    // 이미지 갱신
    override func refreshDisplay() {
        super.refreshDisplay()
        if isImageCoupon {
            self.isHidden = true
        } else {
            self.isHidden = false
            setNeedsDisplay()
        }
    }
    
    // 링 그리기
    func drawRingFittingInsideView(_ rect: CGRect) {
        let hw:CGFloat = (model?.ringThickness)!/2
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw,dy: hw) )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.hexStringToUIColor(hex: (model?.ringColor)!).cgColor
        shapeLayer.lineWidth = (model?.ringThickness)!
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
        shapeLayer.strokeColor = UIColor.hexStringToUIColor(hex: (model?.checkLineColor)!).cgColor
        shapeLayer.lineWidth = (model?.checkLineWidth)!
        layer.addSublayer(shapeLayer)
    }
    

}
