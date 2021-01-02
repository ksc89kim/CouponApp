//
//  CouponController.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/05/06.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

protocol CouponController {
  func deleteCoupon(merchantId: Int)
  func deleteCouponForTable(merchantId :Int, tableView: UITableView, indexPath: IndexPath)
  func insertCoupon(merchantId: Int)
}
