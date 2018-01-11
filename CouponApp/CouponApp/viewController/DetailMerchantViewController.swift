//
//  DetailMerchantViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 10..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     가맹점 상세 보기
     - 회원 가맹점 추가하기
     - 회원 가맹점 삭제하기
 */
class DetailMerchantViewController: UIViewController {

    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var merchantContent: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var merchantModel:MerchantModel?
    var isUserCoupon:Bool = false //회원 쿠폰 여부

    override func viewDidLoad() {
        super.viewDidLoad()
        if let merchant = merchantModel {
            merchantName.text = merchant.name
            logoImage.downloadedFrom(link: merchant.logoImageUrl!)
            merchantContent.text = merchant.content
            let userId = CouponSignleton.sharedInstance.userId
            do {
                isUserCoupon = try SQLInterface().isUserCoupon(userId!,merchant.merchantId!)
            } catch {
                isUserCoupon = false
            }
        }
        refreshButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //버튼 라벨 갱신
    func refreshButton() {
        if isUserCoupon {
            button.setTitle("삭제하기", for: .normal)
        } else {
            button.setTitle("추가하기", for: .normal)
        }
    }
    
    // 추가하기, 삭제하기 액션
    @IBAction func clickAction(_ sender: Any) {
        if let merchant = merchantModel {
            if isUserCoupon {
                deleteCoupon(merchantModel: merchant)
            } else { //추가하기
                insertCoupon(merchantModel: merchant)
            }
        }
    }
    
    //삭제하기
    func deleteCoupon(merchantModel:MerchantModel){
         let userId = CouponSignleton.sharedInstance.userId
        do{
            try SQLInterface().deleteCounpon(userId!, merchantModel.merchantId!, complete: {
                isUserCoupon = false
                refreshButton()
            })
        } catch {
            print("삭제하기 실패")
        }
    }
    
    //추가하기
    func insertCoupon(merchantModel:MerchantModel){
         let userId = CouponSignleton.sharedInstance.userId
        do {
            try SQLInterface().insertCoupon(userId!, merchantModel.merchantId!, complete: {
                isUserCoupon = true
                refreshButton()
            })
        } catch {
            print("추가하기 실패")
        }
    }

}
