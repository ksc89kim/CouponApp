//
//  MerchantTabBarController.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/18.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import UIKit

protocol MerchantTabBarType {
  var usermerchant: UserMerchantTableViewController? { get }
  var merchant: MerchantViewController? { get }
}


final class MerchantTabBarController: UITabBarController, MerchantTabBarType {

  var usermerchant: UserMerchantTableViewController? {
    return self.children.compactMap { (viewController: UIViewController) -> UserMerchantTableViewController? in
      return viewController.children.compactMap { (viewController: UIViewController) -> UserMerchantTableViewController?  in
        return viewController as? UserMerchantTableViewController
      }
      .first
    }
    .first
  }

  var merchant: MerchantViewController? {
    return self.children.compactMap { (viewController: UIViewController) -> MerchantViewController? in
      return viewController.children.compactMap { (viewController: UIViewController) -> MerchantViewController?  in
        return viewController as? MerchantViewController
      }
      .first
    }
    .first
  }
}
