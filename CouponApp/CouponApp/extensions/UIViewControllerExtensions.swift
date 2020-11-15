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

  func createViewController(storyboardName:String, withIdentifier:String) -> UIViewController {
    let storyBoard = UIStoryboard(name:storyboardName, bundle:Bundle.main)
    let viewController = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
    return viewController
  }

  func createViewController(storyboardName:String) -> UIViewController {
    let storyBoard = UIStoryboard(name:storyboardName, bundle:Bundle.main)
    let mainViewController = storyBoard.instantiateInitialViewController() ?? UIViewController()
    return mainViewController
  }


  func addViewController(viewController:UIViewController, bringSubView:UIView) {
    self.addChildViewController(viewController)
    self.view.addSubview(viewController.view)
    self.view.bringSubview(toFront:bringSubView)
  }

  func addCustomViewController(viewController:UIViewController){
    DispatchQueue.main.async {
      if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
        window.addSubview(viewController.view)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
      } else if let navigationController =  self.navigationController{
        navigationController.view.addSubview(viewController.view)
        navigationController.addChildViewController(viewController)
        viewController.didMove(toParentViewController: navigationController)
      } else {
        self.view.addSubview(viewController.view)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
      }
    }
  }

  func showAlert(data: Alert){
    self.showAlert(title: data.title, message: data.message)
  }

  func showAlert(title:String, message:String) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }

  func showCustomPopup(data: CustomPopup){
    self.showCustomPopup(title: data.title, message: data.message, callback: data.callback)
  }

  func showCustomPopup(title:String, message:String, callback:(() -> Void)? = nil){
    DispatchQueue.main.async {
      let customPopupViewController:CustomPopupViewController = CustomPopupViewController(nibName: "CustomPopupViewController", bundle: nil)
      customPopupViewController.okCallback = callback
      customPopupViewController.titleText = title
      customPopupViewController.contentText = message
      customPopupViewController.view.frame = self.view.frame
      self.addCustomViewController(viewController: customPopupViewController)
    }
  }

}

extension Reactive where Base: UIViewController {

  var showCustomPopup: Binder<CustomPopup> {
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
