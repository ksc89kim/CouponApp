//
//  MerchantTableViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 2. 9..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

class MerchantTableViewCell: UITableViewCell {
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var grayLineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let dashLineLayer:CAShapeLayer = CAShapeLayer()
    var model:MerchantModel?
    
    deinit {
        lineView.layer.removeObserver(self, forKeyPath: "bounds")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setUI() {
        backGroundView.layer.cornerRadius = 5
        backGroundView.layer.shadowOpacity = 0.18
        backGroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backGroundView.layer.shadowRadius = 2
        backGroundView.layer.shadowColor = UIColor.black.cgColor
        backGroundView.layer.masksToBounds = false
        
        topView.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        logoImageView.layer.cornerRadius = logoImageView.bounds.width/2
        grayLineView.layer.cornerRadius = 5
        
        lineView.addDashLine(dashLayer:dashLineLayer,color: UIColor.white, lineWidth: 3)
        lineView.layer.addObserver(self, forKeyPath:"bounds", options:.new, context: nil)
    }
    
    func setData(data:MerchantModel?) {
        guard let marchantModel = data else {
            print("merchantModel nil")
            return
        }
        
        self.titleLabel.text = marchantModel.name
        self.topView.backgroundColor = UIColor.hexStringToUIColor(hex: marchantModel.cardBackGround)
        self.logoImageView.downloadedFrom(link:marchantModel.logoImageUrl)
        self.model = marchantModel
    }
    
    // MARK: -  observe
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            lineView.updateDashLineSize(dashLayer: dashLineLayer)
        }
    }
}
