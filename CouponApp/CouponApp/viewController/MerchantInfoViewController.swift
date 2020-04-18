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
    private var originalHeaderHeight:CGFloat = 163
    
    private var isAnimation:Bool = false
    private var _percent:CGFloat = 0.0
    private var percent:CGFloat {
        get {
            return _percent
        }
        set(newValue){
            if newValue > 0 && newValue < 100 {
                _percent = newValue
            } else if newValue >= 100 {
                _percent = 100
            } else {
                _percent = 0
            }
            
            if !isAnimation {
                self.setAnimationPercent(percent: _percent)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panGesture)
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAnimationPercent(percent: 0)
        self.openAnimation()
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
            headerImageView.setCropRoundedImage(image: merchantInfoModel.cellTopLogoImage ?? UIImage())
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
        isAnimation = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration:0.35, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.setAnimationPercent(percent:100)
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] (isSuccess) in
                if isSuccess {
                    self?.percent = 100
                    self?.isAnimation = false
                }
        })
    }
    
    func closeAnimation(){
        isAnimation = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration:0.35, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.setAnimationPercent(percent:0)
                self?.view.layoutIfNeeded()
            }, completion: { [weak self] (isSucess) in
                if isSucess {
                    self?.percent = 0
                    self?.isAnimation = false
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
    
    @objc func handlePan(_ sender:UIPanGestureRecognizer) {
        guard !isAnimation else {
            return
        }
        
        switch (sender.direction)! {
        case PanDirection.down:
            self.percent -= 1
            break
        case PanDirection.up:
            self.percent += 1
            break
        default:
            break
        }
        
        switch sender.state {
        case .ended,.cancelled, .failed:
            if _percent < 90 {
                closeAnimation()
            } else {
                openAnimation()
            }
            break
        default:
            break
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
