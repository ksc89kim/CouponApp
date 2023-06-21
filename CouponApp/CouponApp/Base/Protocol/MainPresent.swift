//
//  MainPresent.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/06/19.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import RxSwift
import UIKit

protocol MainPresent where Self: BaseViewController {
  func createMainViewController(merchantList: any MerchantListable) -> UIViewController
  func showMainViewController(merchantList: any MerchantListable)
}


extension MainPresent {
  func createMainViewController(merchantList: any MerchantListable) -> UIViewController {
    let mainViewController = ViewControllerFactory.createViewController(storyboardType: .main)
    mainViewController.modalPresentationStyle = .fullScreen
    if let merchantTabBarController = mainViewController as? MerchantTabBarType {
      let userMerchantViewController = merchantTabBarController.usermerchant
      userMerchantViewController?.viewModel.inputs.merchantList.onNext(merchantList)
      merchantTabBarController.merchant?.setMerchantList(merchantList)
    }
    return mainViewController
  }

  func showMainViewController(merchantList: any MerchantListable) {
    let mainViewController = self.createMainViewController(merchantList: merchantList)
    self.present(mainViewController, animated: true, completion: nil)
  }
}


extension Reactive where Base: MainPresent {
  var showMainViewController: Binder<any MerchantListable> {
    return Binder(self.base) { view, merchantList in
      view.showMainViewController(merchantList: merchantList)
    }
  }
}
