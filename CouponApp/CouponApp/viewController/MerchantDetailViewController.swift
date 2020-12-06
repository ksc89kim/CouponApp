//
//  MerchantInfoViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 3. 30..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

final class MerchantDetailViewController: UIViewController, CouponController{
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var merchantDetail:MerchantDetail = MerchantDetail()
    var titleLabel:MerchantAnimatedLabel = MerchantAnimatedLabel()
    
    private var originalHeaderHeight:CGFloat = 163
    private var isAnimation:Bool = false
    private let maxPercent:CGFloat = 100
    private var _percent:CGFloat = 0.0
    private var percent:CGFloat {
        get {
            return _percent
        }
        set(newValue){
            if newValue > 0 && newValue < maxPercent {
                _percent = newValue
            } else if newValue >= maxPercent {
                _percent = maxPercent
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
        
        setUI()
        setPanGesture()
        
        guard let merchant = merchantDetail.merchant else {
            print("merchant nil")
            return
        }
        
        CouponData.checkUserCoupon(userId: CouponSignleton.getUserId(), merchantId: merchant.merchantId, complete: { [weak self] isSuccessed in
            self?.merchantDetail.isUserCoupon = isSuccessed
            self?.updateActionButtonUI()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAnimationPercent(percent: 0)
        self.openAnimation()
    }
    
    // MARK: - 제스처 세팅
    
    private func setPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - UI 세팅

    private func setUI(){
        setHeaderUI()
        setIntroduceUI()
    }
    
    private func setHeaderUI(){
        setTitleUI()
        
        merchantDetail.originalHeaderHeight = headerHeightConstraint.constant
        headerView.backgroundColor = merchantDetail.cellBackgroundColor
        headerImageView.setCropRoundedImage(image: merchantDetail.getCellImage())
    }
    
    private func setTitleUI(){
        guard let merchant = merchantDetail.merchant else {
            print("merchant nil")
            return
        }
        
        titleLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: merchantDetail.titleFontSize)
        titleLabel.textColor = UIColor.white
        titleLabel.cellFont = UIFont(name: "NotoSansCJKkr-Regular", size: merchantDetail.cellFontSize)
        headerView.addSubview(titleLabel)
        
        titleLabel.text = merchant.name
        titleLabel.sizeToFit()
    }
    
    private func setIntroduceUI() {
        guard let merchant = merchantDetail.merchant else {
            print("merchant nil")
            return
        }
        
        introduceLabel.text = merchant.content
    }
    
    // MARK: - 하단 버튼 업데이트

    private func updateActionButtonUI() {
        if merchantDetail.isUserCoupon {
            actionButton.setTitle("삭제하기", for: .normal)
        } else {
            actionButton.setTitle("추가하기", for: .normal)
        }
    }
    
    // MARK: - 애니메이션

    private func setAnimationPercent(percent:CGFloat) {
        setHeaderAnimationPercent(percent: percent)
        setContentAnimationPercent(percent: percent)
    }
    
    private func setHeaderAnimationPercent(percent:CGFloat) {
        let haederMovePosition = (merchantDetail.positionY * percent) / 100
        let headerWidth = ((self.view.frame.width - merchantDetail.getCellWidth()) * percent) / 100
        let headerHeight = ((originalHeaderHeight - merchantDetail.getCellHeight()) * percent) / 100
        
        headerTopConstraint.constant = merchantDetail.positionY - haederMovePosition
        headerWidthConstraint.constant = merchantDetail.getCellWidth() + headerWidth
        headerHeightConstraint.constant = merchantDetail.getCellHeight() + headerHeight
        
        titleLabel.setPercent(percent: percent)
        titleLabel.setPosition(x: headerWidthConstraint.constant - 15, y: 20)
    }
    
    private func setContentAnimationPercent(percent:CGFloat) {
        let contentMovePosition = ((self.view.frame.height - originalHeaderHeight) * percent) / 100
        contentTopConstraint.constant = (self.view.frame.height - originalHeaderHeight) - contentMovePosition
    }
        
    private func moveUI(direction:PanDirection) {
        switch direction {
        case PanDirection.down:
            self.percent -= 1
            break
        case PanDirection.up:
            self.percent += 1
            break
        default:
            break
        }
    }
    
    private func moveAnimation(state: UIGestureRecognizer.State) {
        switch state {
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
    
    private func openAnimation(){
        isAnimation = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration:0.35, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.setAnimationPercent(percent:self?.maxPercent ?? 100)
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] (isSuccess) in
                if isSuccess {
                    self?.percent = self?.maxPercent ?? 100
                    self?.isAnimation = false
                }
        })
    }
    
    private func closeAnimation(){
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
    
    // MARK: - 제스처 기능

    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            closeAnimation()
        }
    }
    
    @objc func handlePan(_ sender:UIPanGestureRecognizer) {
        guard !isAnimation else {
            return
        }
        
        moveUI(direction: sender.direction!)
        moveAnimation(state:sender.state)
    }
    
    // MARK: - 하단 버튼 액션
    
    @IBAction func onEvent(_ sender: Any) {
        guard let merchant = merchantDetail.merchant  else {
            return
        }
        
        if merchantDetail.isUserCoupon {
            deleteCoupon(merchantId: merchant.merchantId)
        } else {
            insertCoupon(merchantId: merchant.merchantId)
        }
    }
    
    // MARK: - CouponController
    
    func deleteCoupon(merchantId:Int){
        CouponData.deleteUserCoupon(userId: CouponSignleton.getUserId(), merchantId: merchantId, complete: { [weak self] isSuccessed in
            guard isSuccessed else  {
//                self?.showCustomPopup(title: "deleteCouponFailTitle".localized, message: "deleteCouponFailContent".localized)
                return
            }
            
//            self?.showCustomPopup(title: "deleteCouponSuccessTitle".localized, message: "deleteCouponSuccessContent".localized)
            self?.merchantDetail.isUserCoupon = false
            self?.updateActionButtonUI()
        })
    }
    
    func deleteCouponForTable(merchantId: Int, tableView: UITableView, indexPath: IndexPath) {
    }
    
    func insertCoupon(merchantId:Int){
        CouponData.insertUserCoupon(userId: CouponSignleton.getUserId(), merchantId: merchantId, complete: { [weak self] isSuccessed in
            guard isSuccessed else {
//                self?.showCustomPopup(title: "insertCouponFailTitle".localized, message: "insertCouponFailContent".localized)
                return
            }
            
//            self?.showCustomPopup(title: "insertCouponSuccessTitle".localized, message: "insertCouponSuccessContent".localized)
            self?.merchantDetail.isUserCoupon = true
            self?.updateActionButtonUI()
        })
    }
}
