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
        if let userId = CouponSignleton.sharedInstance.userId {
            goMain()
        } else {
            loginWithSignView.isHidden = false
        }
        
    }
    

    @IBAction func loginUser(_ sender: Any) {
    }
    
    @IBAction func signUser(_ sender: Any) {
    }
    
    func goMain() {
        let storyBoard = UIStoryboard(name:"Main", bundle:Bundle.main)
        let initalViewController = storyBoard.instantiateInitialViewController()
        self.show(initalViewController!, sender: nil)
    }
    
    @IBAction func unwindToStartView(segue:UIStoryboardSegue) {

    }

}
