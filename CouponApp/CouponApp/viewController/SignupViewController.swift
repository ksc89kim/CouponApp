//
//  SignupViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.delegate = self
        password.delegate = self
        name.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSignup(_ sender: Any) {
        let phoneNumberNeedInput = NSLocalizedString("phoneNumberNeedInput", comment: "")
        let passwordNeedInput = NSLocalizedString("passwordNeedInput", comment: "")
        let signupFailTitle = NSLocalizedString("signupFailTitle", comment: "")
        let signupFailContent = NSLocalizedString("signupFailContent", comment: "")
    
        guard (phoneNumber.text != nil && (phoneNumber.text?.count)! > 0 ) else {
            CouponSignleton.showCustomPopup(title: signupFailTitle, message: phoneNumberNeedInput, callback: nil)
            return
        }
        guard (password.text != nil && (password.text?.count)! > 0 ) else {
            CouponSignleton.showCustomPopup(title: signupFailTitle, message:passwordNeedInput, callback: nil)
            return
        }
        do {
            try SQLInterface().insertUser(phoneNumber: phoneNumber.text!, password: password.text!, name: name.text!, complete:{ isSuccess in
                guard isSuccess else {
                    CouponSignleton.showCustomPopup(title: signupFailTitle, message: signupFailContent, callback: nil)
                    return
                }
                do {
                    CouponSignleton.sharedInstance.userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber.text!)
                    if CouponSignleton.sharedInstance.userId != nil {
                        UserDefaults.standard.set(phoneNumber.text, forKey: DefaultKey.phoneNumber.rawValue)
                        goMain()
                    } else {
                        CouponSignleton.showCustomPopup(title: signupFailTitle, message: signupFailContent, callback: nil)
                    }
                } catch {
                    CouponSignleton.showCustomPopup(title: signupFailTitle, message: signupFailContent, callback: nil)
                }
            })
        } catch {
            CouponSignleton.showCustomPopup(title: signupFailTitle, message: signupFailContent, callback: nil)
        }
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let initalViewController = storyBoard.instantiateInitialViewController()
        self.show(initalViewController!, sender: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        var limitCount = 20
        if phoneNumber == textField {
            limitCount = 11
        } else if password == textField {
            limitCount = 12
        }
        return newLength <= limitCount
    }
    

}
