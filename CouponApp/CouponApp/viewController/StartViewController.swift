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
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var isCompleteMerchantData:Bool = false
    
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
        // 전체 가맹점 불러오기
        self.getMerchantData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    func getMerchantData() {
        CouponNetwork.requestGetMerchantData(complete: { [weak self] isSuccessed in
            if isSuccessed {
                let phoneNumberString = UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
                if let phoneNumber = phoneNumberString {
                    CouponNetwork.requestUserData(phoneNumber: phoneNumber, complete: { [weak self] isSuccessed in
                        self?.isCompleteMerchantData = true
                        if isSuccessed {
                            self?.goMain()
                        }
                    })
                } else {
                     self?.isCompleteMerchantData = true
                }
            } else {
                self?.getMerchantData()
            }
        })
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        let phoneNumberNeedInput = NSLocalizedString("phoneNumberNeedInput", comment: "")
        let passwordNeedInput = NSLocalizedString("passwordNeedInput", comment: "")
        let loginFailTitle = NSLocalizedString("loginFailTitle", comment: "")
        let phoneNumberOrPasswordFail = NSLocalizedString("phoneNumberOrPasswordFail", comment: "")
        
        guard (phoneNumberTextField.text != nil && (phoneNumberTextField.text?.count)! > 0 ) else {
            Utils.showCustomPopup(title: loginFailTitle, message: phoneNumberNeedInput, callback: nil)
            return
        }
        guard (passwordTextField.text != nil && (passwordTextField.text?.count)! > 0 ) else {
            Utils.showCustomPopup(title: loginFailTitle, message: passwordNeedInput, callback: nil)
            return
        }
        
        CouponNetwork.requestCheckPassword(phoneNumber: phoneNumberTextField.text!, password:passwordTextField.text!, complete: { [weak self] isSuccessed in
            if isSuccessed {
                UserDefaults.standard.set(self?.phoneNumberTextField.text, forKey: DefaultKey.phoneNumber.rawValue)
                self?.goMain()
            } else {
                Utils.showCustomPopup( title: loginFailTitle, message: phoneNumberOrPasswordFail, callback: nil)
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
