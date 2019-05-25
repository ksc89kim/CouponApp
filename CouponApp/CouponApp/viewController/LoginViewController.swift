//
//  LoginViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     로그인 뷰컨트롤러
 */
class LoginViewController: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField! // 로그인 - 전화번호 입력 필드
    @IBOutlet weak var passwordTextField: UITextField! // 로그인 - 패스워드 입력 필드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        Utils.setUpViewHeight(self.view, sender)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        let loginFailTitle = "loginFailTitle".localized
        let phoneNumberOrPasswordFail = "phoneNumberOrPasswordFail".localized
            
        guard let phoneNumberText =  phoneNumberTextField.text, !phoneNumberText.isEmpty else {
            self.showCustomPopup(title: loginFailTitle, message: "phoneNumberNeedInput".localized)
            return
        }
        
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {
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
}
