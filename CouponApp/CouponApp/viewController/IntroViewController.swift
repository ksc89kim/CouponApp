//
//  IntroViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 11/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

/*
 인트로 뷰컨트롤러
 */
class IntroViewController: UIViewController {
    @IBOutlet weak var stampView: IntroStampView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMerchantData()
        self.stampView.completion = { [weak self] in
            self?.fadeAnimation()
        };
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Animation Function
    
    private func fadeAnimation() {
        self.backgroundView.alpha = 1
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        self?.backgroundView.alpha = 0
            },
                       completion: { [weak self] finished in
                        if finished {
                            self?.backgroundView.isHidden = true
                        }
            }
        )
    }
    
    // MARK: - Get Data

    private func getPhoneNumber() -> String? {
        return UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
    }
    
    // MARK: - Load Data
    
    private func loadMerchantData() {
        CouponData.loadMerchantData(complete: { [weak self] isSuccessed in
            if isSuccessed {
                if let phoneNumber = self?.getPhoneNumber() {
                    self?.loadUserData(phoneNumber: phoneNumber)
                } else {
                    self?.showLoginViewController()
                }
            } else {
                self?.showLoginViewController()
            }
        })
    }
    
    private func loadUserData(phoneNumber:String) {
        CouponData.loadUserData(phoneNumber: phoneNumber, complete: { [weak self] isSuccessed in
            if isSuccessed {
                self?.showMainViewController()
            } else {
                self?.showLoginViewController()
            }
        })
    }
    
    // MARK: - Show ViewController
    
    private func showLoginViewController() {
        guard let bringSubView = self.backgroundView else {
            print("showLoginViewController - backgorundView nil")
            return
        }
        
        let loginViewController =  self.createViewController(storyboardName: CouponStoryBoardName.start.rawValue, withIdentifier:CouponIdentifier.loginNavigationController.rawValue)
        self.addViewController(viewController: loginViewController,bringSubView:bringSubView)
    }
    
    private func showMainViewController() {
        guard let bringSubView = self.backgroundView else {
            print("showMainViewController - backgorundView nil")
            return
        }
        
        let mainViewcontroller =  self.createViewController(storyboardName: CouponStoryBoardName.main.rawValue)
        self.addViewController(viewController: mainViewcontroller,bringSubView:bringSubView)
    }
    
}
