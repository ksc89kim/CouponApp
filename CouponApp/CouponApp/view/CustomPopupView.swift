//
//  CustomPopupView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 19..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     커스텀 팝업 뷰
*/
class CustomPopupView: UIView {
    
    @IBOutlet weak var popupView: RoundedView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    var okCallback:(() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.commonInitialization()
        popupView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        showAnimation()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        self.commonInitialization()
        popupView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        showAnimation()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("CustomPopupView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
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
        self.removeFromSuperview()
    }
}
