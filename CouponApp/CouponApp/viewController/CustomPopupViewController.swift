//
//  CustomPopupViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class CustomPopupViewController: UIViewController {
    @IBOutlet weak var popupView: RoundedView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popupCenterYConstraint: NSLayoutConstraint!
    
    var okCallback:(() -> Void)?
    var contentText:String = ""
    var titleText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        contentLabel.text = contentText
        popupView.alpha = 0
        let deadlineTime = DispatchTime.now() + .milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            self?.showAnimation()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimation() {
        showFadeInAnimation()
    }
    
    func showGiveAnimation() {
        popupView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations:{ [weak self] in
            self?.popupView.transform = .identity
        }, completion: nil)
    }
    
    func showFadeInAnimation() {
        popupCenterYConstraint.constant = 0
        UIView.animate(withDuration:0.35, animations: { [weak self] in
            self?.popupView.alpha = 1
            self?.view.layoutIfNeeded()
        })
    }
    
    @IBAction func onOk(_ sender: Any) {
        if okCallback != nil {
            okCallback!()
        }
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
