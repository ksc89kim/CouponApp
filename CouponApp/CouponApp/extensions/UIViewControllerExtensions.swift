//
//  CPUIViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 20..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

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
    
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
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


