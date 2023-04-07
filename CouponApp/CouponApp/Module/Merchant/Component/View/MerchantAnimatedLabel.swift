//
//  MerchantLabel.swift
//  CouponApp
//
//  Created by kim sunchul on 19/08/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

final class MerchantAnimatedLabel: UILabel {

  //MARK: - Property

  var cellFont: UIFont?
  var scalePoint = CGPoint(x: 1, y: 1)

  //MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  //MARK: - Set Method
  
  func setPercent(_ percent: CGFloat) {
    guard let scale = self.getScale() else {
      return
    }
    
    let percentScaleX = ((1 - scale.x) * percent) / 100
    let percentScaleY = ((1 - scale.y) * percent) / 100
    self.scalePoint.x = scale.x + percentScaleX
    self.scalePoint.y = scale.y + percentScaleY
    
    self.transform = CGAffineTransform(scaleX: self.scalePoint.x , y: self.scalePoint.y)
  }
  
  func setPosition(_ position: CGPoint) {
    self.frame.origin.x = position.x - (self.bounds.width * self.scalePoint.x);
    self.frame.origin.y = position.y;
  }

  //MARK: - Get Method

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