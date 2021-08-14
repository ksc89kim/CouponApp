//
//  CouponIdentifier.swift
//  CouponApp
//
//  Created by kim sunchul on 13/07/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import Foundation

enum CouponIdentifier: String{

  // MARK: - ViewController identifier

  case loginNavigationController = "loginNavigationController"
  case globalMerchantTableViewController = "globalMerchantTableViewController"
  case aroundMerchantTableViewController = "aroundMerchantTableViewController"

  // MARK: - Show segue identifier

  case showSignupViewController = "showSignupViewController"
  case showCouponListView = "showCouponListView"
  
  // MARK: - Unwind segue identifier
  case unwindLoginViewController = "unwindLoginViewController"
  case unwindUserMerchant = "unwindUserMerchant"
  
  // MARK: - Cell identifier
  case merchantTableViewCell = "MerchantTableViewCell"
}
