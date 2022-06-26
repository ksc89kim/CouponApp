//
//  CouponView.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/05/11.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import Foundation

protocol CouponViewType {
  var uiData: CouponUIType? { get set }
  func updateUI()
}
