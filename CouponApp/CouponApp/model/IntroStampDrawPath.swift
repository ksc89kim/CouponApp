//
//  IntroStamp.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/05/11.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

struct IntroStampDrawPath {
    let width:CGFloat
    let height:CGFloat
    var rateX:CGFloat
    var rateY:CGFloat
    let path:UIBezierPath = UIBezierPath()
    
    init(drawRect:CGRect, parentRect:CGRect) {
        self.width = drawRect.size.width
        self.height = drawRect.size.height
        self.rateX = parentRect.size.width/drawRect.size.width
        self.rateY = parentRect.size.height/drawRect.size.height
    }
    
    mutating func setRate(parentRect:CGRect) {
        self.rateX = parentRect.size.width/self.width
        self.rateY = parentRect.size.height/self.height
    }
    
    func draw() {
        path.removeAllPoints()
        drawTopStamp()
        drawBottomPedestal()
    }
    
    private func drawTopStamp() {
        path.move(to: CGPoint(x:53 * rateX, y:18 * rateY))
        path.addCurve(to: CGPoint(x:70 * rateX, y:3 * rateY), controlPoint1: CGPoint(x:53 * rateX, y:18 * rateY), controlPoint2: CGPoint(x:59 * rateX, y:7 * rateY))
        path.addCurve(to: CGPoint(x:94 * rateX, y:3 * rateY), controlPoint1: CGPoint(x:70 * rateX, y:3 * rateY), controlPoint2: CGPoint(x:78 * rateX, y:-2 * rateY))
        path.addCurve(to: CGPoint(x:115 * rateX, y:37 * rateY), controlPoint1: CGPoint(x:94 * rateX, y:3 * rateY), controlPoint2: CGPoint(x:114 * rateX, y:11 * rateY))
        path.addCurve(to: CGPoint(x:103 * rateX, y:66 * rateY), controlPoint1: CGPoint(x:115 * rateX, y:37 * rateY), controlPoint2: CGPoint(x:117 * rateX, y:51 * rateY))
        path.addCurve(to: CGPoint(x:97 * rateX, y:92 * rateY), controlPoint1: CGPoint(x:103 * rateX, y:66 * rateY), controlPoint2: CGPoint(x:96 * rateX, y:76 * rateY))
        path.addCurve(to: CGPoint(x:106 * rateX, y:109 * rateY), controlPoint1: CGPoint(x:97 * rateX, y:92 * rateY), controlPoint2: CGPoint(x:96 * rateX, y:102 * rateY))
        path.addCurve(to: CGPoint(x:118 * rateX, y:115 * rateY), controlPoint1: CGPoint(x:106 * rateX, y:109 * rateY), controlPoint2: CGPoint(x:113 * rateX, y:115 * rateY))
        path.addCurve(to: CGPoint(x:152 * rateX, y:116 * rateY), controlPoint1: CGPoint(x:118 * rateX, y:115 * rateY), controlPoint2: CGPoint(x:152 * rateX, y:116 * rateY))
        path.addCurve(to: CGPoint(x:161 * rateX, y:124 * rateY), controlPoint1: CGPoint(x:152 * rateX, y:116 * rateY), controlPoint2: CGPoint(x:158 * rateX, y:116 * rateY))
        path.addCurve(to: CGPoint(x:161 * rateX, y:135 * rateY), controlPoint1: CGPoint(x:161 * rateX, y:124 * rateY), controlPoint2: CGPoint(x:161 * rateX, y:135 * rateY))
        path.addCurve(to: CGPoint(x:151 * rateX, y:146 * rateY), controlPoint1: CGPoint(x:161 * rateX, y:135 * rateY), controlPoint2: CGPoint(x:162 * rateX, y:143 * rateY))
        path.addCurve(to: CGPoint(x:10 * rateX, y:145 * rateY), controlPoint1: CGPoint(x:151 * rateX, y:146 * rateY), controlPoint2: CGPoint(x:10 * rateX, y:145 * rateY))
        path.addCurve(to: CGPoint(x:2 * rateX, y:138 * rateY), controlPoint1: CGPoint(x:10 * rateX, y:145 * rateY), controlPoint2: CGPoint(x:5 * rateX, y:144 * rateY))
        path.addCurve(to: CGPoint(x:1 * rateX, y:125 * rateY), controlPoint1: CGPoint(x:2 * rateX, y:138 * rateY), controlPoint2: CGPoint(x:1 * rateX, y:125 * rateY))
        path.addCurve(to: CGPoint(x:11 * rateX, y:116 * rateY), controlPoint1: CGPoint(x:1 * rateX, y:125 * rateY), controlPoint2: CGPoint(x:3 * rateX, y:117 * rateY))
        path.addCurve(to: CGPoint(x:39 * rateX, y:116 * rateY), controlPoint1: CGPoint(x:11 * rateX, y:116 * rateY), controlPoint2: CGPoint(x:39 * rateX, y:116 * rateY))
        path.addCurve(to: CGPoint(x:60 * rateX, y:103 * rateY), controlPoint1: CGPoint(x:39 * rateX, y:116 * rateY), controlPoint2: CGPoint(x:55 * rateX, y:111 * rateY))
        path.addCurve(to: CGPoint(x:63 * rateX, y:80 * rateY), controlPoint1: CGPoint(x:60 * rateX, y:103 * rateY), controlPoint2: CGPoint(x:67 * rateX, y:94 * rateY))
        path.addCurve(to: CGPoint(x:50 * rateX, y:54 * rateY), controlPoint1: CGPoint(x:63 * rateX, y:80 * rateY), controlPoint2: CGPoint(x:57 * rateX, y:63 * rateY))
        path.addCurve(to: CGPoint(x:47 * rateX, y:32 * rateY), controlPoint1: CGPoint(x:50 * rateX, y:54 * rateY), controlPoint2: CGPoint(x:45 * rateX, y:42 * rateY))
        path.addCurve(to: CGPoint(x:53 * rateX, y:18 * rateY), controlPoint1: CGPoint(x:48 * rateX, y:24 * rateY), controlPoint2: CGPoint(x:53 * rateX, y:18 * rateY))
    }
    
    private func drawBottomPedestal() {
        path.move(to: CGPoint(x:88 * rateX, y:149 * rateY))
        path.addCurve(to: CGPoint(x:156 * rateX, y:149 * rateY), controlPoint1: CGPoint(x:88 * rateX, y:149 * rateY), controlPoint2: CGPoint(x:156 * rateX, y:149 * rateY))
        path.addCurve(to: CGPoint(x:161 * rateX, y:154 * rateY), controlPoint1: CGPoint(x:156 * rateX, y:149 * rateY), controlPoint2: CGPoint(x:161 * rateX, y:150 * rateY))
        path.addCurve(to: CGPoint(x:157 * rateX, y:160 * rateY), controlPoint1: CGPoint(x:161 * rateX, y:154 * rateY), controlPoint2: CGPoint(x:162 * rateX, y:158 * rateY))
        path.addCurve(to: CGPoint(x:6 * rateX, y:160 * rateY), controlPoint1: CGPoint(x:157 * rateX, y:160 * rateY), controlPoint2: CGPoint(x:6 * rateX, y:160 * rateY))
        path.addCurve(to: CGPoint(x:1 * rateX, y:154 * rateY), controlPoint1: CGPoint(x:6 * rateX, y:160 * rateY), controlPoint2: CGPoint(x:1 * rateX, y:160 * rateY))
        path.addCurve(to: CGPoint(x:6 * rateX, y:149 * rateY), controlPoint1: CGPoint(x:1 * rateX, y:154 * rateY), controlPoint2: CGPoint(x:1 * rateX, y:149 * rateY))
        path.addCurve(to: CGPoint(x:88 * rateX, y:149 * rateY), controlPoint1: CGPoint(x:88 * rateX, y:149 * rateY), controlPoint2: CGPoint(x:88 * rateX, y:149 * rateY))
        path.close()
    }
}
