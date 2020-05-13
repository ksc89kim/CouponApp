//
//  MerchantLabel.swift
//  CouponApp
//
//  Created by kim sunchul on 19/08/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

final class MerchantAnimatedLabel: UILabel {
    var cellFont:UIFont?
    var scalePoint:CGPoint = CGPoint(x: 1, y: 1)
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    private func setUI() {
        
    }
    
    func setPercent(percent:CGFloat) {
        guard let scale = self.getScale() else {
            return
        }
        
        let percentScaleX = ((1 - scale.x) * percent) / 100
        let percentScaleY = ((1 - scale.y) * percent) / 100
        scalePoint.x = scale.x + percentScaleX
        scalePoint.y = scale.y + percentScaleY
        
        self.transform = CGAffineTransform(scaleX:scalePoint.x , y: scalePoint.y)
    }
    
    func setPosition(x:CGFloat, y:CGFloat) {
        frame.origin.x = x - (bounds.width * scalePoint.x);
        frame.origin.y = y;
    }
    
    private func getScale() -> CGPoint? {
        guard frame.size != .zero else {
            return nil
        }
        
        guard let font = cellFont else {
            return nil
        }
        
        guard let titleSize = text?.size(OfFont: font) else {
            return nil
        }
        
        return CGPoint(x: titleSize.width / bounds.size.width, y: titleSize.height / bounds.size.height)
    }

}
