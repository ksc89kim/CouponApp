//
//  MerchantTextLayer.swift
//  CouponApp
//
//  Created by kim sunchul on 25/07/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

final class MerchantAnimatedTextLayer: CATextLayer {

  //MARK: - Property

  var uifont: UIFont? {
    didSet {
      font = self.uifont?.fontName as CFTypeRef
      fontSize = self.uifont?.pointSize ?? 0
    }
  }
  
  var text: String? {
    didSet {
      string = self.text
      let size:CGSize = self.text?.size(OfFont: self.uifont!) ?? .zero
      if size != .zero {
        frame.size = size
      }
    }
  }
  
  var cellFont: UIFont?
  var scalePoint = CGPoint(x: 1, y: 1)

  //MARK: - Life Cycle

  override func layoutSublayers() {
    super.layoutSublayers()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  //MARK: - Set Function

  func setPercent(percent: CGFloat) {
    guard let scale = self.getScale() else {
      return
    }
    
    let percentScaleX = ((1 - scale.x) * percent) / 100
    let percentScaleY = ((1 - scale.y) * percent) / 100
    self.scalePoint.x = scale.x + percentScaleX
    self.scalePoint.y = scale.y + percentScaleY
    
    self.setAffineTransform(CGAffineTransform(scaleX: self.scalePoint.x , y: self.scalePoint.y))
  }
  
  func setPosition(x: CGFloat, y: CGFloat) {
    self.frame.origin.x = x - (self.bounds.width * self.scalePoint.x);
    self.frame.origin.y = y;
  }
  
  private func getScale() -> CGPoint? {
    guard self.frame.size != .zero else {
      return nil
    }
    
    guard let font = self.cellFont else {
      return nil
    }
    
    guard let titleSize = self.text?.size(OfFont: font) else {
      return nil
    }
    
    return CGPoint(x: titleSize.width / self.bounds.size.width, y: titleSize.height / self.bounds.size.height)
  }
  
}
