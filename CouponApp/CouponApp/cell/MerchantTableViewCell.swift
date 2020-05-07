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
    
    let headerTopHeight:CGFloat = 86
    let dashLineLayer:CAShapeLayer = CAShapeLayer()
    weak var merchant:MerchantImpl?
    
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
    
    func setData(data:MerchantImpl?) {
        guard let merchant = data else {
            print("merchantModel nil")
            return
        }
        
        self.titleLabel.text = merchant.name
        self.topView.backgroundColor = UIColor.hexStringToUIColor(hex: merchant.cardBackGround)
        self.logoImageView.downloadedFrom(link:merchant.logoImageUrl)
        self.merchant = merchant
    }
    
    func showDetail(parentViewController:UIViewController, tableView:UITableView) {
        let customPopupViewController:MerchantDetailViewController = MerchantDetailViewController(nibName: CouponNibName.merchantDetailViewController.rawValue, bundle: nil)
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            customPopupViewController.merchantDetail.setCellData(cell: self, offsetY: tableView.contentOffset.y)
            customPopupViewController.view.frame = window.frame

            window.addSubview(customPopupViewController.view)
            parentViewController.addChildViewController(customPopupViewController)
            customPopupViewController.didMove(toParentViewController: parentViewController)
        }
    }
    
    // MARK: -  observe
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            lineView.updateDashLineSize(dashLayer: dashLineLayer)
        }
    }
}
