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
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.delegate = self
        password.delegate = self
        name.delegate = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
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
        phoneNumber.resignFirstResponder()
        password.resignFirstResponder()
        name.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickSignup(_ sender: Any) {
        let phoneNumberNeedInput = NSLocalizedString("phoneNumberNeedInput", comment: "")
        let passwordNeedInput = NSLocalizedString("passwordNeedInput", comment: "")
        let signupFailTitle = NSLocalizedString("signupFailTitle", comment: "")
        let signupFailContent = NSLocalizedString("signupFailContent", comment: "")
    
        guard (phoneNumber.text != nil && (phoneNumber.text?.count)! > 0 ) else {
            Utils.showCustomPopup(title: signupFailTitle, message: phoneNumberNeedInput, callback: nil)
            return
        }
        guard (password.text != nil && (password.text?.count)! > 0 ) else {
            Utils.showCustomPopup(title: signupFailTitle, message:passwordNeedInput, callback: nil)
            return
        }
        
        CouponNetwork.requestSignup(phoneNumber: phoneNumber.text!, password: password.text!, name: name.text!, complete:{ isSuccessed in
            guard isSuccessed else {
                Utils.showCustomPopup(title: signupFailTitle, message: signupFailContent, callback: nil)
                return
            }
            
            CouponNetwork.requestUserData(phoneNumber: self.phoneNumber.text!, complete: { isSuccessed in
                if isSuccessed {
                    UserDefaults.standard.set(self.phoneNumber.text, forKey: DefaultKey.phoneNumber.rawValue)
                    self.goMain()
                } else {
                     Utils.showCustomPopup(title: signupFailTitle, message: signupFailContent, callback: nil)
                }
            })
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        var limitCount = 20
        if phoneNumber == textField {
            limitCount = 11
        } else if password == textField {
            limitCount = 12
        }
        return newLength <= limitCount
    }
    
    func goLeftAnimation() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
}
