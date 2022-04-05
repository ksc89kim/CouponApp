//
//  CPUIImageView.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 7. 26..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RxSwift
import RxCocoa

extension UIImageView {
  func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
    contentMode = mode
    AF.request(URL(fileURLWithPath: link)).responseImage { [weak self] response in
      guard let image = response.value else {
        return
      }
      self?.image = image
    }
  }

  func setCropRoundedImage(image: UIImage) {
    let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    let imageView: UIImageView = UIImageView(frame: frame)
    imageView.backgroundColor = UIColor.clear
    imageView.contentMode = .scaleAspectFill
    imageView.image = image
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = frame.size.width/2

    UIGraphicsBeginImageContext(frame.size)
    imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.image = roundedImage
  }
}


extension Reactive where Base: UIImageView {
  var cropRoundedImage: Binder<UIImage> {
    return Binder(self.base) { view, image in
      view.setCropRoundedImage(image: image)
    }
  }
}
