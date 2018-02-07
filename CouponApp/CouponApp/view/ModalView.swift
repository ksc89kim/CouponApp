//
//  ModalView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 2. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import SVProgressHUD

class ModalView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
        SVProgressHUD.show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
        SVProgressHUD.show()
    }
    
    deinit{
        
    }
    
}
