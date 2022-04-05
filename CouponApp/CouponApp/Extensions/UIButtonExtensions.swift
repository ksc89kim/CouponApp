//
//  CPUIButton.swift
//  CouponApp
//
//  Created by kim sunchul on 26/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

extension UIButton {
  func plusate() {
    let pluse = CASpringAnimation(keyPath: "transform.scale")
    pluse.duration = 0.6
    pluse.fromValue = 0.95
    pluse.toValue = 1.0
    pluse.autoreverses = true
    pluse.initialVelocity = 0.5
    pluse.damping = 1.0
    layer.add(pluse, forKey: nil)
  }

  func flash() {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.5
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 3
    layer.add(flash, forKey: nil)
  }

  func shake() {
    let shake = CABasicAnimation(keyPath: "position")
    shake.duration = 0.1
    shake.repeatCount = 2
    shake.autoreverses = true

    let fromPoint = CGPoint(x: center.x - 5, y: center.y)
    let fromValue = NSValue(cgPoint: fromPoint)

    let toPoint = CGPoint(x: center.x + 5, y: center.y)
    let toValue = NSValue(cgPoint: toPoint)

    shake.fromValue = fromValue
    shake.toValue = toValue

    layer.add(shake, forKey:nil)
  }
}

