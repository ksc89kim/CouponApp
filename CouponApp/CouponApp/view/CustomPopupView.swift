//
//  CustomPopupView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 19..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class CustomPopupView: UIView {
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    var okCallback:(() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        self.commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("CustomPopupView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func clickOk(_ sender: Any) {
        if okCallback != nil {
            okCallback!()
        }
        self.removeFromSuperview()
    }
}
