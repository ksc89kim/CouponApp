//
//  CouponListViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 8. 15..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit
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
    
    @IBAction func clickRequestCoupon(_ sender: Any) {
        let couponCount = (userMerchantData?.couponCount)!;
        let maxCount = (merchantData?.maxCouponCount)!;
        guard couponCount < maxCount else {
            printAlert(title: "쿠폰 최대치!", message: "모든 쿠폰을 모았습니다.\n쿠폰을 소진해주세요.")
            return
        }
        userMerchantData?.couponCount = couponCount + 1
        do {
            try SQLInterface().updateCouponCount(1,(merchantData?.merchantId)!,(userMerchantData?.couponCount)!,complete: {
                myCollectionView.reloadData()
            })
        } catch {
            print(error)
        }
    }
    
    @IBAction func clickUseCopon(_ sender: Any) {
        let couponCount = (userMerchantData?.couponCount)!;
        let maxCount = (merchantData?.maxCouponCount)!;
        guard couponCount >= maxCount else {
            printAlert(title: "쿠폰 부족!", message: "쿠폰이 부족합니다.\n쿠폰을 더 모아주세요.")
            return
        }
        userMerchantData?.couponCount = 0
        do {
            try SQLInterface().updateCouponCount(1,(merchantData?.merchantId)!,(userMerchantData?.couponCount)!,complete: {
                myCollectionView.reloadData()
            })
        } catch {
            print(error)
        }
    }
    
    
    func printAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
        
    /*
        UICollectionViewDataSource method
    */
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (merchantData?.maxCouponCount)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath)
        let couponView:CouponView = cell.viewWithTag(500) as! CouponView // tag에 붙은 CouponView를 가지고 온다.
        if indexPath.row < (userMerchantData?.couponCount)! {
            couponView.isUseCoupone = true // 쿠폰 활성화
        } else {
            couponView.isUseCoupone = false // 쿠폰 비활성화
        }
        couponView.frame.size = cellSize // 사이즈 재설정
        couponView.setNeedsDisplay()
        return cell
    }
    

}
