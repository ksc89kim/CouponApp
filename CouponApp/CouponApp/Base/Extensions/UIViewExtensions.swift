//
//  CPUIView.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 2. 3..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

extension UIView {
  
  func addDashLine(dashLayer: CAShapeLayer, color: UIColor, lineWidth: CGFloat) {
    dashLayer.strokeColor = color.cgColor
    dashLayer.lineWidth = lineWidth
    dashLayer.lineDashPattern = [2,3]
    self.updateDashLineSize(dashLayer: dashLayer)
    self.layer.addSublayer(dashLayer)
  }

  func updateDashLineSize(dashLayer: CAShapeLayer) {
    let path = CGMutablePath()
    path.addLines(between: [CGPoint(x: 0, y: 0),
                            CGPoint(x: self.frame.width, y: 0)])
    dashLayer.path = path
  }
}

extension Reactive where Base: UIView {
  var boundsDidChange: Observable<CGRect> {
    return self.base.rx.observe(CGRect.self, #keyPath(UIView.bounds)).filterNil()
  }
}

