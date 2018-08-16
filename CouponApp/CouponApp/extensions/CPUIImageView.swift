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

extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        Alamofire.request(link).responseImage(completionHandler: { [weak self] response in
            guard let image = response.result.value else {
                return
            }
            self?.image = image
        })
    }
}

