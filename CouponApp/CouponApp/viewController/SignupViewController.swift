//
//  SignupViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import AnimatedTextInput

/*
     가입 뷰컨트롤러
 */
class SignupViewController: UIViewController , AnimatedTextInputDelegate{
    @IBOutlet weak var nameTextInput: AnimatedTextInput!
    @IBOutlet weak var phoneNumberTextInput: AnimatedTextInput!
    @IBOutlet weak var passwordTextInput: AnimatedTextInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Set Function
    func setUI(){
        nameTextInput.placeHolderText  = "UserName"
        nameTextInput.style = CustomTextInputStyle()
        
        phoneNumberTextInput.placeHolderText  = "PhoneNumber"
        phoneNumberTextInput.type = .phone;
        phoneNumberTextInput.delegate = self
        phoneNumberTextInput.style = CustomTextInputStyle()
        
        passwordTextInput.placeHolderText  = "Password"
        passwordTextInput.type = .password(toggleable: true)
        phoneNumberTextInput.delegate = self
        passwordTextInput.style = CustomTextInputStyle()
    }
    
    // MARK: - Event Function
    @IBAction func onSignUp(_ sender: Any) {
        let signupFailTitle = "signupFailTitle".localized
        let signupFailContent = "signupFailContent".localized
        
        guard let nameText = nameTextInput.text, !nameText.isEmpty else {
            self.showCustomPopup(title: signupFailTitle, message: "nameNeedInput".localized)
            return
        }
        
        guard let phoneNumberText =  phoneNumberTextInput.text, !phoneNumberText.isEmpty else {
            self.showCustomPopup(title: signupFailTitle, message: "phoneNumberNeedInput".localized)
            return
        }
        
        guard let passwordText = passwordTextInput.text, !passwordText.isEmpty else {
            self.showCustomPopup(title: signupFailTitle, message:"passwordNeedInput".localized)
            return
        }

        CouponData.signup(phoneNumber: phoneNumberText, password: passwordText, name: nameText, complete:{ [weak self] isSuccessed in
            guard isSuccessed else {
                self?.showCustomPopup(title: signupFailTitle, message: signupFailContent)
                return
            }
            
            CouponData.getUserData(phoneNumber: phoneNumberText, complete: { [weak self] isSuccessed in
                if isSuccessed {
                    UserDefaults.standard.set(phoneNumberText, forKey: DefaultKey.phoneNumber.rawValue)
                    self?.goMain()
                } else {
                    self?.showCustomPopup(title: signupFailTitle, message: signupFailContent)
                }
            })
        })
    }
    
    // MARK: - Etc Function
    func goMain() {
        let mainViewController:UIViewController = self.createViewController(storyboardName: CouponStoryBoardName.main.rawValue)
        self.present(mainViewController, animated: true, completion: nil)
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
    
}
