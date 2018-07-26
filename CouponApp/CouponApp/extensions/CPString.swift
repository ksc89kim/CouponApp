//
//  CPString.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 7. 26..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

extension String{
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    var localized:String {
        return NSLocalizedString(self,comment:"")
    }
}
