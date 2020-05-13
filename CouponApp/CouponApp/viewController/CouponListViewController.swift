//
//  CouponListViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 8. 15..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

/*
 쿠폰 리스트 뷰 컨트롤러
 - 현재 가지고 있는 쿠폰 갯수와, 채울 수 있는 최대 쿠폰 갯수를 보여주는 뷰 컨트롤러
 - 쿠폰 소진하기 및 쿠폰 요청하기 기능이 있음.
 */
class CouponListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var backgroundRoundedView: UIView!
    @IBOutlet weak var bottomButtonRoundedView: UIView!
    @IBOutlet weak var dotLineView: UIView!
    @IBOutlet weak var leftHoleView: UIView!
    @IBOutlet weak var rightHoleView: UIView!
    
    private let cellSize:CGSize = CGSize(width: 50 , height:50)
    private var selectCouponIndex:NSInteger?
    private let dashLineLayer:CAShapeLayer = CAShapeLayer()
    
    var userCouponData:UserCoupon?
    var merchantData:MerchantImpl?
    
    deinit {
        dotLineView.layer.removeObserver(self, forKeyPath:"bounds")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUI() {
        self.navigationItem.title = merchantData?.name
        
        setBackgroundRoundedView(view:backgroundRoundedView)
        setHoleView(view: leftHoleView)
        setHoleView(view: rightHoleView)
        setBottomButtonRoundedView()
        setCollectionView()
        addDashLineAndObserver()
    }
    
    private func setBottomButtonRoundedView() {
        bottomButtonRoundedView.layer.borderWidth = 1
        bottomButtonRoundedView.layer.borderColor = UIColor.couponGrayColor2.cgColor
    }
    
    private func setBackgroundRoundedView(view:UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.couponGrayColor1.cgColor
        view.layer.cornerRadius = 10
    }
    
    private func setHoleView(view:UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.couponGrayColor1.cgColor
        view.layer.cornerRadius = view.frame.size.width/2
    }
    
    private func setCollectionView() {
        myCollectionView.setCollectionViewLayout(getCollectionViewFlowLayout(), animated: true)
        myCollectionView.reloadData()
    }
    
    private func getCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        return layout
    }
    
    private func addDashLineAndObserver() {
        dotLineView.addDashLine(dashLayer: dashLineLayer, color: UIColor.couponGrayColor1, lineWidth: 2)
        dotLineView.layer.addObserver(self, forKeyPath: "bounds", options: .new, context:nil)
    }
    
    // MARK: - 쿠폰 요청하기
    @IBAction func onRequestCoupon(_ sender: Any) {
        guard let couponCount = userCouponData?.couponCount, let merchant =  merchantData else {
            print("onRequestCoupon - userMerchantData, merchantData error")
            return
        }
        
        let maxCount = merchant.couponCount()
        
        guard couponCount < maxCount else {
            self.showCustomPopup(title: "maxCouponTitle".localized, message:"maxCouponContent".localized)
            return
        }
        
        CouponData.updateUesrCoupon(userId: CouponSignleton.getUserId(), merchantId: merchant.merchantId, couponCount: couponCount + 1, complete: { [weak self] isSuccessed in
            if isSuccessed {
                self?.userCouponData?.addCouponCount()
                self?.selectCouponIndex = couponCount
                self?.myCollectionView.reloadData()
            } else {
                self?.showCustomPopup(title:"requestFailCouponTitle".localized, message: "requestFailCouponContent".localized)
            }
        })
    }
    
    // MARK: - 쿠폰 사용하기
    @IBAction func onUseCopon(_ sender: Any) {
        guard let couponCount = userCouponData?.couponCount, let merchant = merchantData else {
            print("onUseCopon - userMerchantData, merchantData error")
            return
        }
        
        let maxCount = merchant.couponCount()
        guard couponCount >= maxCount else {
            self.showCustomPopup(title: "lackCouponTitle".localized, message: "lackCouponContent".localized,callback: nil)
            return
        }
        
        CouponData.updateUesrCoupon(userId: CouponSignleton.getUserId(), merchantId: merchant.merchantId, couponCount: 0, complete: { [weak self] isSuccessed in
            if isSuccessed {
                self?.showCustomPopup(title: "successUseCouponTitle".localized, message: "successUseCouponContent".localized,callback: nil)
                self?.userCouponData?.clearCouponCount()
                self?.myCollectionView.reloadData()
            } else {
                self?.showCustomPopup(title:"useCouponFailTitle".localized, message:"useCouponFailContent".localized)
            }
        })
    }
    
    
    // MARK: -  UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let merchant = merchantData else {
            print("collectionView - merchantData error")
            return 0
        }
        return merchant.couponCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CouponCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath) as! CouponCollectionViewCell
        
        guard let merchant = merchantData, let couponCount = userCouponData?.couponCount else  {
            print("collectionView - merchantData error,  couponCount error")
            return cell
        }
        
        var coupon:CouponUI = merchant.index(indexPath.row)
        coupon.isUseCoupon = (indexPath.row < couponCount)
        coupon.isAnimation = (indexPath.row == selectCouponIndex)
        cell.updateUI(coupon: coupon)
        
        return cell
    }
    
    
    // MARK: -  observe
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            dotLineView.updateDashLineSize(dashLayer: dashLineLayer)
        }
    }
}
