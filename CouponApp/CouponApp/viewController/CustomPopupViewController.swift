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
    var okCallback:(() -> Void)?
    var contentText:String = ""
    var titleText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        contentLabel.text = contentText
        popupView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        showAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations:{
            self.popupView.transform = .identity
        }, completion: nil)
    }
    
    @IBAction func clickOk(_ sender: Any) {
        if okCallback != nil {
            okCallback!()
        }
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
