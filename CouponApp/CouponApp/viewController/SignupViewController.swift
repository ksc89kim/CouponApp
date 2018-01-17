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
        guard (phoneNumber.text != nil) else { return }
        guard (password.text != nil) else { return }
        do {
            try SQLInterface().insertUser(phoneNumber: phoneNumber.text!, password: password.text!, name: name.text!, complete: {
                UserDefaults.standard.set(phoneNumber.text, forKey: DefaultKey.phoneNumber.rawValue)
                do {
                    CouponSignleton.sharedInstance.userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber.text!)
                    if CouponSignleton.sharedInstance.userId != nil {
                        goMain()
                    } else {
                        CouponSignleton.printAlert(viewController: self, title: "회원가입 실패", message: "회원 가입에 실패하였습니다.\n 다시 시도 해주세요.")
                    }
                } catch {
                    CouponSignleton.printAlert(viewController: self, title: "회원가입 실패", message: "회원 가입에 실패하였습니다.\n 다시 시도 해주세요.")
                }
            })
        } catch {
            CouponSignleton.printAlert(viewController: self, title: "회원가입 실패", message: "회원 가입에 실패하였습니다.\n 다시 시도 해주세요.")
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
