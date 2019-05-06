//
//  MerchantInfoViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 3. 30..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

class MerchantInfoViewController: UIViewController {
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var titleLabel:UILabel = UILabel()
    
    var merchantInfoModel:MerchantInfoModel = MerchantInfoModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openAnimation()
    }
    
    func setHeaderImageView(image:UIImage) {
        headerImageView.setCropRoundedImage(image: image)
    }
    
    func setUI(){
        merchantInfoModel.originalHeaderHeight = headerHeightConstraint.constant

        titleLabel.frame = CGRect(x: headerView.frame.width - 20, y: 20, width: 100, height: 100)
        titleLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: merchantInfoModel.titleFontSize)
        titleLabel.textColor = UIColor.white
        headerView.addSubview(titleLabel)
        
        if let merchant = merchantInfoModel.merchantModel {
            titleLabel.text = merchant.name
            titleLabel.sizeToFit()
            headerView.backgroundColor = merchantInfoModel.cellTopView?.backgroundColor
            introduceLabel.text = merchant.content
            let userId = CouponSignleton.instance.userData?.id
            
            CouponData.checkUserCoupon(userId: userId!, merchantId: merchant.merchantId, complete: { [weak self] isSuccessed in
                self?.merchantInfoModel.isUserCoupon = isSuccessed
                self?.setButtonTitle()
            })
        }
        
        setTitleScale()
        setButtonTitle()
    }
    
    func setTitleScale(){
        titleLabel.sizeToFit()
        
        let labelCopy = titleLabel.copyLabel()
        labelCopy.font = titleLabel.font.withSize(merchantInfoModel.cellFontSize)
        
        var bounds = labelCopy.bounds
        bounds.size = labelCopy.intrinsicContentSize
        
        let frame = titleLabel.frame
        if frame.size.width > 0 && frame.size.height > 0 {
            merchantInfoModel.titleScaleX = bounds.size.width / titleLabel.frame.size.width
            merchantInfoModel.titleScaleY = bounds.size.height / titleLabel.frame.size.height
        }
    }
    
    func setTitleFrame() {
        self.titleLabel.frame = CGRect(x: self.headerWidthConstraint.constant - 15 - self.titleLabel.frame.size.width, y: 20, width: self.titleLabel.frame.size.width, height: self.titleLabel.frame.size.height)
    }
    
    func setButtonTitle() {
        if merchantInfoModel.isUserCoupon {
            actionButton.setTitle("삭제하기", for: .normal)
        } else {
            actionButton.setTitle("추가하기", for: .normal)
        }
    }
    
    func openAnimation(){
        merchantInfoModel.cellTopView?.isHidden = true
        
        headerTopConstraint.constant = merchantInfoModel.positionY
        headerWidthConstraint.constant = merchantInfoModel.getCellWidth()
        headerHeightConstraint.constant = merchantInfoModel.getCellHeight()
        contentTopConstraint.constant = self.view.frame.height
        backgroundView.alpha = 0.5
        
        self.titleLabel.transform = CGAffineTransform(scaleX: merchantInfoModel.titleScaleX, y: merchantInfoModel.titleScaleY)
        self.setTitleFrame()
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration:0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.headerWidthConstraint.constant = self?.view.frame.width ?? 0
            self?.headerHeightConstraint.constant = self?.merchantInfoModel.originalHeaderHeight ?? 0
            self?.headerTopConstraint.constant = 0
            self?.contentTopConstraint.constant = 0
            self?.backgroundView.alpha = 1.0
            
            self?.titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.setTitleFrame()
            self?.view.layoutIfNeeded()
            
        }, completion: { [weak self] (isSuccess) in
            self?.titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.setTitleFrame()
        })
    }
    
    func fadeInAnimation() {
        headerImageView.alpha = 0
        UIView.animate(withDuration:0.3, delay: 0, options: .curveEaseOut, animations: {
            self.headerImageView.alpha = 1
        }, completion: nil)
    }
    
    func closeAnimation(){
        headerWidthConstraint.constant = self.view.frame.width
        headerHeightConstraint.constant = merchantInfoModel.originalHeaderHeight
        headerTopConstraint.constant = 0
        contentTopConstraint.constant = 0
        backgroundView.alpha = 1.0
        
        self.titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.setTitleFrame()

        self.view.layoutIfNeeded()

        UIView.animate(withDuration:0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.headerTopConstraint.constant = self?.merchantInfoModel.positionY ?? 0
            self?.headerWidthConstraint.constant = self?.merchantInfoModel.getCellWidth() ?? 0
            self?.headerHeightConstraint.constant = self?.merchantInfoModel.getCellHeight() ?? 0
            self?.contentTopConstraint.constant = self?.view.frame.height ?? 0
            self?.backgroundView.alpha = 0.5
            
            self?.titleLabel.transform = CGAffineTransform(scaleX:self?.merchantInfoModel.titleScaleX ?? 1, y: self?.merchantInfoModel.titleScaleY ?? 1)
            self?.setTitleFrame()
            self?.view.layoutIfNeeded()
            
        }, completion: { [weak self] (isSucess) in
            if isSucess {
                self?.merchantInfoModel.cellTopView?.isHidden = false
                self?.view.removeFromSuperview()
                self?.willMove(toParentViewController: nil)
                self?.removeFromParentViewController()
            }
        })
    }
    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            closeAnimation()
        }
    }

    @IBAction func clickEvent(_ sender: Any) {
        guard let merchant = merchantInfoModel.merchantModel  else {
            return
        }
        
        if merchantInfoModel.isUserCoupon {
            deleteCoupon(merchantModel: merchant)
        } else { //추가하기
            insertCoupon(merchantModel: merchant)
        }
    }
    
    //삭제하기
    func deleteCoupon(merchantModel:MerchantModel){
        let userId = CouponSignleton.instance.userData?.id
        let deleteCouponFailTitle = NSLocalizedString("deleteCouponFailTitle", comment: "")
        let deleteCouponFailContent = NSLocalizedString("deleteCouponFailContent", comment: "")
        let deleteCouponSuccessTitle = NSLocalizedString("deleteCouponSuccessTitle", comment: "")
        let deleteCouponSuccessContent = NSLocalizedString("deleteCouponSuccessContent", comment: "")
        
        CouponData.deleteUserCoupon(userId: userId!, merchantId: merchantModel.merchantId, complete: { [weak self] isSuccessed in
            if isSuccessed {
                self?.showCustomPopup(title: deleteCouponSuccessTitle, message: deleteCouponSuccessContent)
                self?.merchantInfoModel.isUserCoupon = false
                self?.setButtonTitle()
            } else {
                self?.showCustomPopup(title: deleteCouponFailTitle, message: deleteCouponFailContent)
            }
        })
    }
    
    //추가하기
    func insertCoupon(merchantModel:MerchantModel){
        let userId = CouponSignleton.instance.userData?.id
        let insertCouponFailTitle = NSLocalizedString("insertCouponFailTitle", comment: "")
        let insertCouponFailContent = NSLocalizedString("insertCouponFailContent", comment: "")
        let insertCouponSuccessTitle = NSLocalizedString("insertCouponSuccessTitle", comment: "")
        let insertCouponSuccessContent = NSLocalizedString("insertCouponSuccessContent", comment: "")

        CouponData.insertUserCoupon(userId: userId!, merchantId: merchantModel.merchantId, complete: { [weak self] isSuccessed in
            guard isSuccessed else {
                self?.showCustomPopup(title: insertCouponFailTitle, message: insertCouponFailContent)
                return
            }
            
            self?.showCustomPopup(title: insertCouponSuccessTitle, message: insertCouponSuccessContent)
            self?.merchantInfoModel.isUserCoupon = true
            self?.setButtonTitle()
        })
    }
}
