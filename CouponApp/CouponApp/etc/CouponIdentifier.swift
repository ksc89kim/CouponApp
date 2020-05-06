//
//  CouponIdentifier.swift
//  CouponApp
//
//  Created by kim sunchul on 13/07/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import Foundation

enum CouponIdentifier:String{
    // viewController identifier
    case loginNavigationController = "loginNavigationController"
    case globalMerchantTableViewController = "globalMerchantTableViewController"
    case aroundMerchantTableViewController = "aroundMerchantTableViewController"

    // show segue identifier
    case showSignupViewController = "showSignupViewController"
    case showCouponListView = "showCouponListView"
    
    // unwind segue identifier
    case unwindLoginViewController = "unwindLoginViewController"
    case unwindUserMerchant = "unwindUserMerchant"
    
    // cell identifier
    case merchantTableViewCell = "MerchantTableViewCell"
}
