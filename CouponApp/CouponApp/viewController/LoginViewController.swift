//
//  LoginViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

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
        let loginFailContent = NSLocalizedString("loginFailContent", comment: "")
        let phoneNumberOrPasswordFail = NSLocalizedString("phoneNumberOrPasswordFail", comment: "")
        
        guard (phoneNumber.text != nil && (phoneNumber.text?.count)! > 0 ) else {
            CouponSignleton.showCustomPopup(title: loginFailTitle, message: phoneNumberNeedInput, callback: nil)
            return
        }
        guard (password.text != nil && (password.text?.count)! > 0 ) else {
            CouponSignleton.showCustomPopup(title: loginFailTitle, message: passwordNeedInput, callback: nil)
            return
        }
        do {
            CouponSignleton.sharedInstance.userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber.text!, password:password.text!)
            if CouponSignleton.sharedInstance.userId != nil {
                UserDefaults.standard.set(phoneNumber.text, forKey: DefaultKey.phoneNumber.rawValue)
                goMain()
            } else {
                CouponSignleton.showCustomPopup( title: loginFailTitle, message: phoneNumberOrPasswordFail, callback: nil)
            }
        } catch {
            CouponSignleton.showCustomPopup(title: loginFailTitle, message: loginFailContent, callback: nil)
        }
        
        
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let initalViewController = storyBoard.instantiateInitialViewController()
        self.show(initalViewController!, sender: nil)
    }

}
