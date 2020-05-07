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
    @IBOutlet weak var bottomRoundedView: UIView!
    @IBOutlet weak var dotLineView: UIView!
    @IBOutlet weak var leftRoundedView: UIView!
    @IBOutlet weak var rightRoundedView: UIView!
    
    private let cellSize:CGSize = CGSize(width: 50 , height:50)
    private var selectCouponIndex:NSInteger?
    private let dashLineLayer:CAShapeLayer = CAShapeLayer()
    
    var userMerchantData:UserCoupon?
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
    
    func setUI() {
        self.navigationItem.title = merchantData?.name
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        myCollectionView.setCollectionViewLayout(layout, animated: true)
        myCollectionView.reloadData()
        
        bottomRoundedView.layer.borderWidth = 1
        bottomRoundedView.layer.borderColor = UIColor.couponGrayColor2.cgColor
        
        dotLineView.addDashLine(dashLayer: dashLineLayer, color: UIColor.couponGrayColor1, lineWidth: 2)
        dotLineView.layer.addObserver(self, forKeyPath: "bounds", options: .new, context:nil)
        
        let roundedColor = UIColor.couponGrayColor1
        self.setRoundedView(view:backgroundRoundedView, width: 1, color:roundedColor , radius: 10)
        self.setRoundedView(view: leftRoundedView, width: 1, color: roundedColor, radius:leftRoundedView.frame.size.width/2)
        self.setRoundedView(view: rightRoundedView, width: 1, color: roundedColor, radius:leftRoundedView.frame.size.width/2)
    }
    
    func setRoundedView(view:UIView, width:CGFloat, color:UIColor, radius:CGFloat) {
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
        view.layer.cornerRadius = radius
    }
    
    // 쿠폰 요청하기
    @IBAction func onRequestCoupon(_ sender: Any) {
        guard let couponCount = userMerchantData?.couponCount, let merchant =  merchantData else {
            print("onRequestCoupon - userMerchantData, merchantData error")
            return
        }
        
        let maxCount = merchant.couponCount()
        
        guard couponCount < maxCount else {
            self.showCustomPopup(title: "maxCouponTitle".localized, message:"maxCouponContent".localized)
            return
        }
        
        guard let userId = CouponSignleton.instance.userData?.id else {
            print("onRequestCoupon - userId error")
            return
        }
        
        CouponData.updateUesrCoupon(userId: userId, merchantId: merchant.merchantId, couponCount: couponCount + 1, complete: { [weak self] isSuccessed in
            if isSuccessed {
                self?.userMerchantData?.couponCount = couponCount + 1
                self?.selectCouponIndex = couponCount
                self?.myCollectionView.reloadData()
            } else {
                self?.showCustomPopup(title:"requestFailCouponTitle".localized, message: "requestFailCouponContent".localized)
            }
        })
    }
    
    // 쿠폰 사용하기
    @IBAction func onUseCopon(_ sender: Any) {
        guard let couponCount = userMerchantData?.couponCount, let merchant = merchantData else {
            print("onUseCopon - userMerchantData, merchantData error")
            return
        }
        
        let maxCount = merchant.couponCount()
        guard couponCount >= maxCount else {
            self.showCustomPopup(title: "lackCouponTitle".localized, message: "lackCouponContent".localized,callback: nil)
            return
        }
        
        guard let userId = CouponSignleton.instance.userData?.id else {
            print("onUseCopon - userId error")
            return
        }

        CouponData.updateUesrCoupon(userId: userId, merchantId: merchant.merchantId, couponCount: 0, complete: { [weak self] isSuccessed in
            if isSuccessed {
                self?.showCustomPopup(title: "successUseCouponTitle".localized, message: "successUseCouponContent".localized,callback: nil)
                self?.userMerchantData?.couponCount = 0
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
        
        guard let merchant = merchantData, let couponCount = userMerchantData?.couponCount else  {
            print("collectionView - merchantData error,  couponCount error")
            return cell
        }
        
        var coupon:CouponUI = merchant.index(indexPath.row)
        coupon.isUseCoupon = (indexPath.row < couponCount)
        coupon.isAnimation = (indexPath.row == selectCouponIndex)
        cell.refreshView(coupon: coupon)
        
        return cell
    }
    
    
    // MARK: -  observe
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            dotLineView.updateDashLineSize(dashLayer: dashLineLayer)
        }
    }
}
