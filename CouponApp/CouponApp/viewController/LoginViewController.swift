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
final class LoginViewController: UIViewController, AnimatedTextInputDelegate{
    @IBOutlet weak var phoneNumberTextInput: AnimatedTextInput!
    @IBOutlet weak var passwordTextInput: AnimatedTextInput!
    
    private let maxPhoneNumber:Int = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Set Function
    private func setUI(){
        setPhoneNumberTextInput()
        setPasswordTextInput()
    }
    
    private func setPhoneNumberTextInput() {
        phoneNumberTextInput.placeHolderText  = "PhoneNumber"
        phoneNumberTextInput.type = .phone
        phoneNumberTextInput.delegate = self
        phoneNumberTextInput.style = CustomTextInputStyle()
    }
    
    private func setPasswordTextInput() {
        passwordTextInput.placeHolderText = "Password"
        passwordTextInput.type = .password(toggleable: true)
        passwordTextInput.delegate = self
        passwordTextInput.style = CustomTextInputStyle()
    }
        
    // MARK: - Unwind Function
    @IBAction func unwindLoginViewController(segue:UIStoryboardSegue) {
        if segue.identifier == CouponIdentifier.unwindLoginViewController.rawValue {
        }
    }
    
    // MARK: - Event Function
    @IBAction func onLogin(_ sender: UIButton) {
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
                self?.showMainViewController()
            } else {
                self?.showCustomPopup(title: loginFailTitle, message: phoneNumberOrPasswordFail, callback: nil)
            }
        })
    }
    
    @IBAction func onSignup(_ sender: Any) {
        showSignupViewController()
    }
    
    // MARK: - Show Function
    private func showMainViewController() {
        let mainViewController:UIViewController = self.createViewController(storyboardName: CouponStoryBoardName.main.rawValue)
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true, completion: nil)
    }
    
    private func showSignupViewController() {
        self.performSegue(withIdentifier:CouponIdentifier.showSignupViewController.rawValue, sender: nil)
    }
    
    // MARK: - AnimatedTextInput Delegate
    func animatedTextInput(animatedTextInput: AnimatedTextInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > getCurrentTextInputCount(animatedTextInput:animatedTextInput) {
            return false
        }
        
        if (animatedTextInput == phoneNumberTextInput) {
            let newLength = getCurrentTextInputCount(animatedTextInput:animatedTextInput) + string.count - range.length
            return newLength <= maxPhoneNumber
        }
        return true
    }
    
    // MARK: - Get Function
    private func getCurrentTextInputCount(animatedTextInput: AnimatedTextInput) -> Int {
        return animatedTextInput.text?.count ?? 0
    }
}

