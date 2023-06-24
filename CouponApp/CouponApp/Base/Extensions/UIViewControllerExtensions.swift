//
//  CPUIViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 20..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
  func addViewController(viewController: UIViewController, bringSubView: UIView) {
    self.addChild(viewController)
    self.view.addSubview(viewController.view)
    self.view.bringSubviewToFront(bringSubView)
  }

  func showAlert(data: Alert){
    self.showAlert(title: data.title, message: data.message)
  }

  fileprivate func showAlert(title: String, message: String) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }

  fileprivate func showCustomPopup(data: CustomPopupConfigurable){
    DispatchQueue.main.async {
      let viewController: CustomPopupViewController = DIContainer.resolve(for: CustomPopupViewControllerKey.self)
      viewController.viewModel.inputs.configure.onNext(data)
      self.present(viewController, animated: true, completion: nil)
    }
  }

  func statusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
  }
}


extension Reactive where Base: UIViewController {
  var showCustomPopup: Binder<CustomPopupConfigurable> {
    return Binder(self.base) { view, data in
      view.showCustomPopup(data: data)
    }
  }

  var showAlert: Binder<Alert> {
    return Binder(self.base) { view, data in
      view.showAlert(data: data)
    }
  }
}
