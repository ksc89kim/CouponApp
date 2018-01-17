//
//  StartViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var loginWithSignView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginWithSignView.isHidden = true
        let phoneNumberString = UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
        if let phoneNumber = phoneNumberString {
            do {
               CouponSignleton.sharedInstance.userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber)
                if CouponSignleton.sharedInstance.userId != nil {
                    goMain()
                } else {
                    loginWithSignView.isHidden = false
                }
            } catch {
                loginWithSignView.isHidden = false
            }
            
        } else {
            loginWithSignView.isHidden = false
        }
        
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let initalViewController = storyBoard.instantiateInitialViewController()
        self.show(initalViewController!, sender: nil)
    }
    
    @IBAction func unwindToStartView(segue:UIStoryboardSegue) {

    }

}
