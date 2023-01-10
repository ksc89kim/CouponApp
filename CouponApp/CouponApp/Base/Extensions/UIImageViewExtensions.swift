//
//  CPUIImageView.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 7. 26..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

extension UIImageView {

  func cropRoundedImage() {
    let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    let imageView: UIImageView = UIImageView(frame: frame)
    imageView.backgroundColor = UIColor.clear
    imageView.contentMode = .scaleAspectFill
    imageView.image = self.image
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = frame.size.width/2

    UIGraphicsBeginImageContext(frame.size)
    imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.image = roundedImage
  }
}
