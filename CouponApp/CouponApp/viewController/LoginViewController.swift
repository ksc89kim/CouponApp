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
        guard (phoneNumber.text != nil && (phoneNumber.text?.count)! > 0 ) else {
            CouponSignleton.printAlert(viewController: self, title: "로그인 실패", message: "전화번호를 입력해주세요")
            return
        }
        guard (password.text != nil && (password.text?.count)! > 0 ) else {
            CouponSignleton.printAlert(viewController: self, title: "로그인 실패", message: "비밀번호를 입력해주세요")
            return
        }
        do {
            CouponSignleton.sharedInstance.userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber.text!, password:password.text!)
            if CouponSignleton.sharedInstance.userId != nil {
                UserDefaults.standard.set(phoneNumber.text, forKey: DefaultKey.phoneNumber.rawValue)
                goMain()
            } else {
                CouponSignleton.printAlert(viewController: self, title: "로그인 실패", message: "전화번호 및 비밀번호가 잘못되었습니다.")
            }
        } catch {
            CouponSignleton.printAlert(viewController: self, title: "로그인 실패", message: "로그인이 실패하였습니다.")
        }
        
        
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let initalViewController = storyBoard.instantiateInitialViewController()
        self.show(initalViewController!, sender: nil)
    }

}
