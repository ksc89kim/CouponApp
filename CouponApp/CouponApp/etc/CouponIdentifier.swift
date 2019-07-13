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
    case publicMerchantViewController = "publicMerchantTableView"
    case nearMerchantViewController = "nearMerchantTableView"

    // show segue identifier
    case showSignupViewController = "showSignupViewController"

    // unwind segue identifier
    case unwindLoginViewController = "unwindLoginViewController"
    
    // cell identifier
    case merchantTableViewCell = "MerchantTableViewCell"
}
