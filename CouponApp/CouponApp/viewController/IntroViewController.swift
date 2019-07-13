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
        self.getMerchantData()
        self.stampView.completion = { [weak self] in
            self?.fadeAnimation()
        };
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Animation Function
    func fadeAnimation() {
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
    
    // MARK: - Get Data Function
    func getMerchantData() {
        guard  let bringSubView = self.backgroundView else {
             print("backgorundView nil");
            return
        }
        
        let loginViewController =  self.createViewController(storyboardName:CouponStoryBoardName.start.rawValue, withIdentifier:CouponIdentifier.loginNavigationController.rawValue)

        CouponData.getMerchantData(complete: { [weak self] isSuccessed in
            if isSuccessed {
                let phoneNumberString = UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
                if let phoneNumber = phoneNumberString {
                    self?.getUserData(phoneNumber: phoneNumber)
                } else {
                    self?.addViewController(viewController: loginViewController, bringSubView:bringSubView)
                }
            } else {
                self?.addViewController(viewController: loginViewController, bringSubView:bringSubView)
            }
        })
    }
    
    func getUserData(phoneNumber:String) {
        CouponData.getUserData(phoneNumber: phoneNumber, complete: { [weak self] isSuccessed in
            guard let bringSubView = self?.backgroundView else {
                print("backgorundView nil");
                return;
            }
            
            if isSuccessed {
                let mainViewcontroller =  self?.createViewController(storyboardName: CouponStoryBoardName.main.rawValue)
                self?.addViewController(viewController: mainViewcontroller ?? UIViewController(),bringSubView:bringSubView)

            } else {
                let loginViewController =  self?.createViewController(storyboardName: CouponStoryBoardName.start.rawValue, withIdentifier:CouponIdentifier.loginNavigationController.rawValue)
                self?.addViewController(viewController: loginViewController ?? UIViewController(),bringSubView:bringSubView)
            }
        })
    }

}
