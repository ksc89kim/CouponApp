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
    
    var merchantInfoModel:MerchantInfoModel = MerchantInfoModel()
    var titleLabel:MerchantLabel = MerchantLabel()
    var originalHeaderHeight:CGFloat = 163
    var originalCompanyLabelHeight:CGFloat = 41
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
        
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAnimationPercent(percent: 0)
        self.openAnimation()
    }
    
    func setHeaderImageView(image:UIImage) {
        headerImageView.setCropRoundedImage(image: image)
    }
    
    func setUI(){
        titleLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: merchantInfoModel.titleFontSize)
        titleLabel.textColor = UIColor.white
        titleLabel.cellFont = UIFont(name: "NotoSansCJKkr-Regular", size: merchantInfoModel.cellFontSize)
        headerView.addSubview(titleLabel)

        merchantInfoModel.originalHeaderHeight = headerHeightConstraint.constant
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
    }
    
    func setButtonTitle() {
        if merchantInfoModel.isUserCoupon {
            actionButton.setTitle("삭제하기", for: .normal)
        } else {
            actionButton.setTitle("추가하기", for: .normal)
        }
    }
    
    func setAnimationPercent(percent:CGFloat) {
        let haederMovePosition = (merchantInfoModel.positionY * percent) / 100
        let headerWidth = ((self.view.frame.width - merchantInfoModel.getCellWidth()) * percent) / 100
        let headerHeight = ((originalHeaderHeight - merchantInfoModel.getCellHeight()) * percent) / 100
        let contentMovePosition = ((self.view.frame.height - originalHeaderHeight) * percent) / 100
      
        headerTopConstraint.constant = merchantInfoModel.positionY - haederMovePosition
        headerWidthConstraint.constant = merchantInfoModel.getCellWidth() + headerWidth
        headerHeightConstraint.constant = merchantInfoModel.getCellHeight() + headerHeight
        contentTopConstraint.constant = (self.view.frame.height - originalHeaderHeight) - contentMovePosition
        
        titleLabel.setPercent(percent: percent)
        titleLabel.setPosition(x: headerWidthConstraint.constant - 15, y: 20)
    }
    
    func openAnimation(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration:3.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.setAnimationPercent(percent: 100)
            self?.view.layoutIfNeeded()
            }, completion: { (isSuccess) in
        })
    }
    
    func closeAnimation(){
        UIView.animate(withDuration:3.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.setAnimationPercent(percent: 0)
                self?.view.layoutIfNeeded()
            }, completion: { [weak self] (isSucess) in
                if isSucess {
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

    @IBAction func onEvent(_ sender: Any) {
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
