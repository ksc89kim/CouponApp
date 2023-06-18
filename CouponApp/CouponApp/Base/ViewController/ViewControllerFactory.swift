//
//  ViewControllerFactory.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/04/04.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import UIKit

struct ViewControllerFactory {
}


extension ViewControllerFactory {
  
  static func createBaseViewController(storyboardType: CouponStoryBoardName, identifierType: CouponIdentifier? = nil) -> BaseViewController? {
    return self.createViewController(storyboardType: storyboardType, identifierType: identifierType) as? BaseViewController
  }

  static func createViewController(storyboardType: CouponStoryBoardName, identifierType: CouponIdentifier? = nil) -> UIViewController {
    return self.createViewController(storyboardName: storyboardType.rawValue, withIdentifier: identifierType?.rawValue)
  }

  static func createViewController(storyboardName: String, withIdentifier: String? = nil) -> UIViewController {
    let storyBoard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
    let viewController: UIViewController
    if let identifier = withIdentifier {
      viewController = storyBoard.instantiateViewController(withIdentifier: identifier)
    } else {
      viewController = storyBoard.instantiateInitialViewController() ?? .init()
    }
    return viewController
  }
}
