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
    var isUserMerchant:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if let merchant = merchantModel {
            merchantName.text = merchant.name
            logoImage.downloadedFrom(link: merchant.logoImageUrl!)
            merchantContent.text = merchant.content
            let userId = CouponSignleton.sharedInstance.userId
            do {
                isUserMerchant = try SQLInterface().isUserMerchant(userId!,merchant.merchantId!)
            } catch {
                isUserMerchant = false
            }
        }
        if isUserMerchant {
            button.setTitle("삭제하기", for: .normal)
        } else {
            button.setTitle("추가하기", for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickAction(_ sender: Any) {
        if isUserMerchant {
        } else {
            
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

}
