//
//  IntroViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 11/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var stampView: IntroStampView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMerchantData()
        self.stampView.completion = { [weak self] in
            self?.fadeAnimation()
        };
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func fadeAnimation() {
        self.backgroundView.alpha = 1
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundView.alpha = 0
        })
    }
    
    func setMerchantData() {
        let loginViewController =  self.createLoginViewController()
        CouponData.getMerchantData(complete: { [weak self] isSuccessed in
            if isSuccessed {
                let phoneNumberString = UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
                if let phoneNumber = phoneNumberString {
                    self?.setUserData(phoneNumber: phoneNumber)
                } else {
                    self?.addViewController(viewController: loginViewController)
                }
            } else {
                self?.addViewController(viewController: loginViewController)
            }
        })
    }
    
    func setUserData(phoneNumber:String) {
        CouponData.getUserData(phoneNumber: phoneNumber, complete: { [weak self] isSuccessed in
            if isSuccessed {
                let mainViewcontroller =  self?.createMainViewController()
                self?.addViewController(viewController: mainViewcontroller ?? UIViewController())

            } else {
                let loginViewController =  self?.createLoginViewController()
                self?.addViewController(viewController: loginViewController ?? UIViewController())
            }
        })
    }
    
    func createLoginViewController() -> UIViewController {
        let storyBoard = UIStoryboard(name:"Start", bundle:Bundle.main)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "loginNavigationController")
        return loginViewController
    }
    
    func createMainViewController() -> UIViewController {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let mainViewController = storyBoard.instantiateInitialViewController() ?? UIViewController()
        return mainViewController
    }
    
    func addViewController(viewController:UIViewController) {
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        self.view.bringSubview(toFront:backgroundView)
    }

}
