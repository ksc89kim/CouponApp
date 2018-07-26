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
    var cellSize:CGSize!
    var userMerchantData:UserCouponModel?
    var merchantData:MerchantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = merchantData?.name
        //iPhone 8 사이즈 기준 CGSize (100,100) Rate 가져오기
        let widthRate:CGFloat = (50/375)
        let heightRate:CGFloat = (50/667)
        let cellWidth : CGFloat = self.view.frame.size.width * widthRate
        let cellheight : CGFloat = self.view.frame.size.height * heightRate
        cellSize = CGSize(width: cellWidth.rounded() , height:cellheight.rounded())
        
        // UICollectionViewFlowLayout 재설정 (cellSize를 다시 설정하기 위하여 새롭게 FlowLayout을 생성한다)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        myCollectionView.setCollectionViewLayout(layout, animated: true)
        
        myCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 쿠폰 요청하기
    @IBAction func clickRequestCoupon(_ sender: Any) {
        guard let couponCount = userMerchantData?.couponCount else {
            print("clickRequestCoupon - userMerchantData error")
            return
        }
        
        guard let merchant = merchantData else {
            print("clickRequestCoupon - merchantData error")
            return
        }
        
        let maxCount = merchant.couponCount()
        
        guard couponCount < maxCount else {
            Utils.showCustomPopup(title: "maxCouponTitle".localized, message:"maxCouponContent".localized)
            return
        }
        
        guard let userId = CouponSignleton.instance.userData?.id else {
            print("clickRequestCoupon - userId error")
            return
        }
        
        guard let merchantId = CouponSignleton.instance.userData?.id else {
            print("clickRequestCoupon - merchantId error")
            return
        }
        
        CouponNetwork.requestUpdateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: couponCount + 1, complete: { [weak self] isSuccessed in
            if isSuccessed {
                self?.userMerchantData?.couponCount = couponCount + 1
                self?.myCollectionView.reloadData()
            } else {
                Utils.showCustomPopup(title:"requestFailCouponTitle".localized, message: "requestFailCouponContent".localized)
            }
        })
    }
    
    // 쿠폰 사용하기
    @IBAction func clickUseCopon(_ sender: Any) {
        guard let couponCount = userMerchantData?.couponCount else {
            print("clickUseCopon - userMerchantData error")
            return
        }
        
        guard let merchant = merchantData else {
            print("clickUseCopon - merchantData error")
            return
        }
        
        let maxCount = merchant.couponCount()

        guard couponCount >= maxCount else {
            Utils.showCustomPopup(title: "lackCouponTitle".localized, message: "lackCouponContent".localized,callback: nil)
            return
        }
        
        guard let userId = CouponSignleton.instance.userData?.id else {
            print("clickUseCopon - userId error")
            return
        }
        
        guard let merchantId = CouponSignleton.instance.userData?.id else {
            print("clickUseCopon - merchantId error")
            return
        }
        
        CouponNetwork.requestUpdateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: 0, complete: { [weak self] isSuccessed in
            if isSuccessed {
                self?.userMerchantData?.couponCount = 0
                self?.myCollectionView.reloadData()
            } else {
                Utils.showCustomPopup(title:"useCouponFailTitle".localized, message:"useCouponFailContent".localized)
            }
        })
    }
 
    
    // MARK: -  UICollectionViewDataSource method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let merchant = merchantData else {
            print("collectionView - merchantData error")
            return 0
        }
        
        return merchant.couponCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath)
        let couponDrawView:CouponDrawView = cell.viewWithTag(500) as! CouponDrawView // tag에 붙은 CouponDrawView를 가지고 온다.
        let couponImageView:CouponImageView = cell.viewWithTag(501) as! CouponImageView // tag에 붙은 CouponImageView를 가지고 온다.
        
        guard let merchant = merchantData else {
            print("collectionView - merchantData error")
            return cell
        }
        
        if let isCouponImage = merchant.isCouponImage, isCouponImage {
            couponImageView.model = merchant.imageCouponList?[indexPath.row]
            couponImageView.isImageCoupon = true
        } else {
            couponDrawView.frame.size = cellSize // 사이즈 재설정
            couponDrawView.model = merchant.drawCouponList?[indexPath.row]
            couponDrawView.isImageCoupon = false
        }
        
        if let couponCount = userMerchantData?.couponCount, indexPath.row < couponCount { // 쿠폰 활성화
            couponDrawView.refreshCoupon(couponStatus: true)
            couponImageView.refreshCoupon(couponStatus: true)
        } else { // 쿠폰 비활성화
            couponDrawView.refreshCoupon(couponStatus: false)
            couponImageView.refreshCoupon(couponStatus: false)
        }
        
        return cell
    }
    

}
