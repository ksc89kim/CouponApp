//
//  CPUIViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 20..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

extension UIViewController {
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
            self.view.addSubview(customPopupViewController.view)
            self.addChildViewController(customPopupViewController)
        }
    }
}


