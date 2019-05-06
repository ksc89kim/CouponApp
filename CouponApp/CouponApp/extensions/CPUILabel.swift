//
//  CPUILabel.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 4. 14..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

extension UILabel {
    func copyLabel() -> UILabel {
        let label = UILabel()
        label.font = self.font
        label.frame = self.frame
        label.text = self.text
        return label
    }
}
