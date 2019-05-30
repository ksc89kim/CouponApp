//
//  LoginViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import AnimatedTextInput

/*
     로그인 뷰컨트롤러
 */
class LoginViewController: UIViewController, AnimatedTextInputDelegate{
    @IBOutlet weak var phoneNumberTextInput: AnimatedTextInput!
    @IBOutlet weak var passwordTextInput: AnimatedTextInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextInput.placeHolderText  = "PhoneNumber"
        phoneNumberTextInput.type = .phone;
        phoneNumberTextInput.delegate = self
        phoneNumberTextInput.style = CustomTextInputStyle()
        
        passwordTextInput.placeHolderText = "Password"
        passwordTextInput.type = .password(toggleable: true)
        passwordTextInput.delegate = self
        passwordTextInput.style = CustomTextInputStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickLogin(_ sender: UIButton) {
        let loginFailTitle = "loginFailTitle".localized
        let phoneNumberOrPasswordFail = "phoneNumberOrPasswordFail".localized
        
        guard let phoneNumberText =  phoneNumberTextInput.text, !phoneNumberText.isEmpty else {
            self.showCustomPopup(title: loginFailTitle, message: "phoneNumberNeedInput".localized)
            return
        }
        
        guard let passwordText = passwordTextInput.text, !passwordText.isEmpty else {
            self.showCustomPopup(title: loginFailTitle, message:"passwordNeedInput".localized)
            return
        }
        
        CouponData.checkPassword(phoneNumber: phoneNumberText, password:passwordText, complete: { [weak self] isSuccessed in
            if isSuccessed {
                UserDefaults.standard.set(phoneNumberText, forKey: DefaultKey.phoneNumber.rawValue)
                self?.goMain()
            } else {
                self?.showCustomPopup(title: loginFailTitle, message: phoneNumberOrPasswordFail, callback: nil)
            }
        })
    }
    
    @IBAction func clickSignup(_ sender: Any) {
        goSignup()
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        if let initalViewController = storyBoard.instantiateInitialViewController() {
            self.present(initalViewController, animated: true, completion: nil)
        }
    }
    
    func goSignup() {
        self.performSegue(withIdentifier: "showSignupViewController", sender: nil)
    }
    
    func animatedTextInput(animatedTextInput: AnimatedTextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = animatedTextInput.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        
        if (animatedTextInput == phoneNumberTextInput) {
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 11
        }
        return true
    }
    
    @IBAction func unwindLoginViewController(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindLoginViewController" {
        }
    }
}

