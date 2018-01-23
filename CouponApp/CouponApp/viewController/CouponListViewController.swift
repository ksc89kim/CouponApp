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
        let couponCount = (userMerchantData?.couponCount)!
        var maxCount = 0
        if (merchantData?.isCouponImage)! {
            maxCount = (merchantData?.imageCouponList?.count)!
        } else {
            maxCount = (merchantData?.drawCouponList?.count)!
        }
        guard couponCount < maxCount else {
            CouponSignleton.showCustomPopup(title: "쿠폰 최대치!", message: "모든 쿠폰을 모았습니다.\n쿠폰을 소진해주세요.",callback: nil)
            return
        }
        userMerchantData?.couponCount = couponCount + 1
        let userId = CouponSignleton.sharedInstance.userId
        do {
            try SQLInterface().updateCouponCount(userId!,(merchantData?.merchantId)!,(userMerchantData?.couponCount)!,complete: { isSuccess in
                guard isSuccess else {
                    CouponSignleton.showCustomPopup(title: "쿠폰 요청 실패", message: "쿠폰 요청이 실패하였습니다.\n다시 시도해주시기 바랍니다. ",callback: nil)
                    return
                }
                myCollectionView.reloadData()
            })
        } catch {
            print(error)
        }
    }
    
    // 쿠폰 사용하기
    @IBAction func clickUseCopon(_ sender: Any) {
        let couponCount = (userMerchantData?.couponCount)!;
        var maxCount = 0
        if (merchantData?.isCouponImage)! {
            maxCount = (merchantData?.imageCouponList?.count)!
        } else {
            maxCount = (merchantData?.drawCouponList?.count)!
        }
        let useCouponFailTitle = NSLocalizedString("useCouponFailTitle", comment: "")
        let useCouponFailContent = NSLocalizedString("useCouponFailContent", comment: "")
        let lackCouponTitle = NSLocalizedString("lackCouponTitle", comment: "")
        let lackCouponContent = NSLocalizedString("lackCouponContent", comment: "")
        
        guard couponCount >= maxCount else {
            CouponSignleton.showCustomPopup(title: lackCouponTitle, message: lackCouponContent,callback: nil)
            return
        }
        userMerchantData?.couponCount = 0
        let userId = CouponSignleton.sharedInstance.userId
        do {
            try SQLInterface().updateCouponCount(userId!,(merchantData?.merchantId)!,(userMerchantData?.couponCount)!,complete: { isSuccess in
                guard isSuccess else {
                    CouponSignleton.showCustomPopup(title: useCouponFailTitle, message: useCouponFailContent,callback: nil)
                    return
                }
                myCollectionView.reloadData()
            })
        } catch {
            print(error)
        }
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: -  UICollectionViewDataSource method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (merchantData?.isCouponImage)! {
            return (merchantData?.imageCouponList?.count)!
        } else {
             return (merchantData?.drawCouponList?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath)
        let couponDrawView:CouponDrawView = cell.viewWithTag(500) as! CouponDrawView // tag에 붙은 CouponDrawView를 가지고 온다.
        let couponImageView:CouponImageView = cell.viewWithTag(501) as! CouponImageView // tag에 붙은 CouponImageView를 가지고 온다.
        
        if (merchantData?.isCouponImage)! {
            couponImageView.model = merchantData?.imageCouponList![indexPath.row]
            couponImageView.isImageCoupon = true;
        } else {
            couponDrawView.frame.size = cellSize // 사이즈 재설정
            couponDrawView.model = merchantData?.drawCouponList![indexPath.row]
            couponDrawView.isImageCoupon = false;
        }
        
        if indexPath.row < (userMerchantData?.couponCount)! { // 쿠폰 활성화
            couponDrawView.refreshCoupon(couponStatus: true)
            couponImageView.refreshCoupon(couponStatus: true)
        } else { // 쿠폰 비활성화
            couponDrawView.refreshCoupon(couponStatus: false)
            couponImageView.refreshCoupon(couponStatus: false)
        }
        return cell
    }
    

}
