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
            couponView.isUseCoupone = true
        } else {
            couponView.isUseCoupone = false
        }
        couponView.frame.size = cellSize // 사이즈 재설정
        return cell
    }
    

}
