//
//  IntroStamp.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/05/11.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

struct IntroStampDrawPath {

  // MARK: - Property

  private let width: CGFloat
  private let height: CGFloat
  private var rateX: CGFloat
  private var rateY: CGFloat
  private let path = UIBezierPath()

  // MARK: - Init

  init(drawRect:CGRect, parentRect:CGRect) {
    self.width = drawRect.size.width
    self.height = drawRect.size.height
    self.rateX = parentRect.size.width/drawRect.size.width
    self.rateY = parentRect.size.height/drawRect.size.height
  }

  // MARK: - Method

  mutating func setRate(parentRect:CGRect) {
    self.rateX = parentRect.size.width/self.width
    self.rateY = parentRect.size.height/self.height
  }
  
  func getCGPath() -> CGPath {
    return self.path.cgPath
  }
  
  func draw() {
    self.path.removeAllPoints()
    self.drawTopStamp()
    self.drawBottomPedestal()
  }
  
  private func drawTopStamp() {
    self.path.move(to: CGPoint(x:53 * self.rateX, y:18 * self.rateY))
    self.path.addCurve(
      to: CGPoint(x:70 * self.rateX, y:3 * self.rateY),
      controlPoint1: CGPoint(x:53 * self.rateX, y:18 * self.rateY),
      controlPoint2: CGPoint(x:59 * self.rateX, y:7 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:94 * self.rateX, y:3 * self.rateY),
      controlPoint1: CGPoint(x:70 * self.rateX, y:3 * self.rateY),
      controlPoint2: CGPoint(x:78 * self.rateX, y:-2 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:115 * self.rateX, y:37 * self.rateY),
      controlPoint1: CGPoint(x:94 * self.rateX, y:3 * self.rateY),
      controlPoint2: CGPoint(x:114 * self.rateX, y:11 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:103 * self.rateX, y:66 * self.rateY),
      controlPoint1: CGPoint(x:115 * self.rateX, y:37 * self.rateY),
      controlPoint2: CGPoint(x:117 * self.rateX, y:51 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:97 * self.rateX, y:92 * self.rateY),
      controlPoint1: CGPoint(x:103 * self.rateX, y:66 * self.rateY),
      controlPoint2: CGPoint(x:96 * self.rateX, y:76 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:106 * self.rateX, y:109 * self.rateY),
      controlPoint1: CGPoint(x:97 * self.rateX, y:92 * self.rateY),
      controlPoint2: CGPoint(x:96 * self.rateX, y:102 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:118 * self.rateX, y:115 * self.rateY),
      controlPoint1: CGPoint(x:106 * self.rateX, y:109 * self.rateY),
      controlPoint2: CGPoint(x:113 * self.rateX, y:115 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:152 * self.rateX, y:116 * self.rateY),
      controlPoint1: CGPoint(x:118 * self.rateX, y:115 * self.rateY),
      controlPoint2: CGPoint(x:152 * self.rateX, y:116 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:161 * self.rateX, y:124 * self.rateY),
      controlPoint1: CGPoint(x:152 * self.rateX, y:116 * self.rateY),
      controlPoint2: CGPoint(x:158 * self.rateX, y:116 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:161 * self.rateX, y:135 * self.rateY),
      controlPoint1: CGPoint(x:161 * self.rateX, y:124 * self.rateY),
      controlPoint2: CGPoint(x:161 * self.rateX, y:135 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:151 * self.rateX, y:146 * self.rateY),
      controlPoint1: CGPoint(x:161 * self.rateX, y:135 * self.rateY),
      controlPoint2: CGPoint(x:162 * self.rateX, y:143 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:10 * self.rateX, y:145 * self.rateY),
      controlPoint1: CGPoint(x:151 * self.rateX, y:146 * self.rateY),
      controlPoint2: CGPoint(x:10 * self.rateX, y:145 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:2 * self.rateX, y:138 * self.rateY),
      controlPoint1: CGPoint(x:10 * self.rateX, y:145 * self.rateY),
      controlPoint2: CGPoint(x:5 * self.rateX, y:144 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:1 * self.rateX, y:125 * self.rateY),
      controlPoint1: CGPoint(x:2 * self.rateX, y:138 * self.rateY),
      controlPoint2: CGPoint(x:1 * self.rateX, y:125 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:11 * self.rateX, y:116 * self.rateY),
      controlPoint1: CGPoint(x:1 * self.rateX, y:125 * self.rateY),
      controlPoint2: CGPoint(x:3 * self.rateX, y:117 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:39 * self.rateX, y:116 * self.rateY),
      controlPoint1: CGPoint(x:11 * self.rateX, y:116 * self.rateY),
      controlPoint2: CGPoint(x:39 * self.rateX, y:116 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:60 * self.rateX, y:103 * self.rateY),
      controlPoint1: CGPoint(x:39 * self.rateX, y:116 * self.rateY),
      controlPoint2: CGPoint(x:55 * self.rateX, y:111 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:63 * self.rateX, y:80 * self.rateY),
      controlPoint1: CGPoint(x:60 * self.rateX, y:103 * self.rateY),
      controlPoint2: CGPoint(x:67 * self.rateX, y:94 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:50 * self.rateX, y:54 * self.rateY),
      controlPoint1: CGPoint(x:63 * self.rateX, y:80 * self.rateY),
      controlPoint2: CGPoint(x:57 * self.rateX, y:63 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:47 * self.rateX, y:32 * self.rateY),
      controlPoint1: CGPoint(x:50 * self.rateX, y:54 * self.rateY),
      controlPoint2: CGPoint(x:45 * self.rateX, y:42 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:53 * self.rateX, y:18 * self.rateY),
      controlPoint1: CGPoint(x:48 * self.rateX, y:24 * self.rateY),
      controlPoint2: CGPoint(x:53 * self.rateX, y:18 * self.rateY)
    )
  }
  
  private func drawBottomPedestal() {
    self.path.move(
      to: CGPoint(x:88 * self.rateX, y:149 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:156 * self.rateX, y:149 * self.rateY),
      controlPoint1: CGPoint(x:88 * self.rateX, y:149 * self.rateY),
      controlPoint2: CGPoint(x:156 * self.rateX, y:149 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:161 * self.rateX, y:154 * self.rateY),
      controlPoint1: CGPoint(x:156 * self.rateX, y:149 * self.rateY),
      controlPoint2: CGPoint(x:161 * self.rateX, y:150 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:157 * self.rateX, y:160 * self.rateY),
      controlPoint1: CGPoint(x:161 * self.rateX, y:154 * self.rateY),
      controlPoint2: CGPoint(x:162 * self.rateX, y:158 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:6 * self.rateX, y:160 * self.rateY),
      controlPoint1: CGPoint(x:157 * self.rateX, y:160 * self.rateY),
      controlPoint2: CGPoint(x:6 * self.rateX, y:160 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:1 * self.rateX, y:154 * self.rateY),
      controlPoint1: CGPoint(x:6 * self.rateX, y:160 * self.rateY),
      controlPoint2: CGPoint(x:1 * self.rateX, y:160 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:6 * self.rateX, y:149 * self.rateY),
      controlPoint1: CGPoint(x:1 * self.rateX, y:154 * self.rateY),
      controlPoint2: CGPoint(x:1 * self.rateX, y:149 * self.rateY)
    )
    self.path.addCurve(
      to: CGPoint(x:88 * self.rateX, y:149 * self.rateY),
      controlPoint1: CGPoint(x:88 * self.rateX, y:149 * self.rateY),
      controlPoint2: CGPoint(x:88 * self.rateX, y:149 * self.rateY)
    )
    self.path.close()
  }
}
