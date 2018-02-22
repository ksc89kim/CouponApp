//
//  LoginViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     로그인 뷰컨트롤러
 */
class LoginViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.delegate = self
        password.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        let phoneNumberNeedInput = NSLocalizedString("phoneNumberNeedInput", comment: "")
        let passwordNeedInput = NSLocalizedString("passwordNeedInput", comment: "")
        let loginFailTitle = NSLocalizedString("loginFailTitle", comment: "")
        //let loginFailContent = NSLocalizedString("loginFailContent", comment: "")
        let phoneNumberOrPasswordFail = NSLocalizedString("phoneNumberOrPasswordFail", comment: "")
        
        guard (phoneNumber.text != nil && (phoneNumber.text?.count)! > 0 ) else {
            CouponSignleton.showCustomPopup(title: loginFailTitle, message: phoneNumberNeedInput, callback: nil)
            return
        }
        guard (password.text != nil && (password.text?.count)! > 0 ) else {
            CouponSignleton.showCustomPopup(title: loginFailTitle, message: passwordNeedInput, callback: nil)
            return
        }
        
        CouponNetwork.requestCheckPassword(phoneNumber: phoneNumber.text!, password:password.text!, complete: { isSuccessed in
            if isSuccessed {
                UserDefaults.standard.set(self.phoneNumber.text, forKey: DefaultKey.phoneNumber.rawValue)
                self.goMain()
            } else {
                CouponSignleton.showCustomPopup( title: loginFailTitle, message: phoneNumberOrPasswordFail, callback: nil)
            }
        })
    }
    
    @IBAction func clickBack(_ sender: Any) {
        goLeftAnimation()
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let initalViewController = storyBoard.instantiateInitialViewController()
        self.show(initalViewController!, sender: nil)
    }
    
    func goLeftAnimation() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }

}
