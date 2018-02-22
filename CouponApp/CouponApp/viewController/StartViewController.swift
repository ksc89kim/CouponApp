//
//  StartViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     시작 뷰컨트롤러
     - 로그인
     - 가입하기
     - 메인으로 가기
 */
class StartViewController: UIViewController {

    @IBOutlet weak var loginWithSignView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginWithSignView.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 전체 가맹점 불러오기
       self.getMerchantData()
    }
    
    func getMerchantData() {
        CouponNetwork.requestGetMerchantData(complete: { isSuccessed in
            self.loginWithSignView.isHidden = true
            if isSuccessed {
                let phoneNumberString = UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
                if let phoneNumber = phoneNumberString {
                    CouponNetwork.requestUserData(phoneNumber: phoneNumber, complete: { isSuccessed in
                        if isSuccessed {
                            self.goMain()
                        } else {
                            self.loginWithSignView.isHidden = false
                        }
                    })
                } else {
                    self.loginWithSignView.isHidden = false
                }
            } else {
                self.getMerchantData()
            }
        })
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let initalViewController = storyBoard.instantiateInitialViewController()
        self.show(initalViewController!, sender: nil)
    }
    
    @IBAction func unwindToStartView(segue:UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginViewController" {
            goRightAnimation()
        } else if segue.identifier == "showSignupViewController" {
            goRightAnimation()
        }
    }
    
    func goRightAnimation() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
}
