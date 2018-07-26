//
//  SignupViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
/*
     가입 뷰컨트롤러
 */
class SignupViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        nameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickSignup(_ sender: Any) {
        let signupFailTitle = "signupFailTitle".localized
        let signupFailContent = "signupFailContent".localized
        
        guard let nameText = nameTextField.text, !nameText.isEmpty else {
            Utils.showCustomPopup(title: signupFailTitle, message: "nameNeedInput".localized)
            return
        }
        
        guard let phoneNumberText =  phoneNumberTextField.text, !phoneNumberText.isEmpty else {
            Utils.showCustomPopup(title: signupFailTitle, message: "phoneNumberNeedInput".localized)
            return
        }
        
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            Utils.showCustomPopup(title: signupFailTitle, message:"passwordNeedInput".localized)
            return
        }

        CouponNetwork.requestSignup(phoneNumber: phoneNumberText, password: passwordText, name: nameText, complete:{ [weak self] isSuccessed in
            guard isSuccessed else {
                Utils.showCustomPopup(title: signupFailTitle, message: signupFailContent)
                return
            }
            
            CouponNetwork.requestUserData(phoneNumber: phoneNumberText, complete: { [weak self] isSuccessed in
                if isSuccessed {
                    UserDefaults.standard.set(phoneNumberText, forKey: DefaultKey.phoneNumber.rawValue)
                    self?.goMain()
                } else {
                     Utils.showCustomPopup(title: signupFailTitle, message: signupFailContent)
                }
            })
        })
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        if let initalViewController = storyBoard.instantiateInitialViewController() {
            self.present(initalViewController, animated: true, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        var limitCount = 20
        if phoneNumberTextField == textField {
            limitCount = 11
        } else if passwordTextField == textField {
            limitCount = 12
        }
        return newLength <= limitCount
    }
    
}
