//
//  UserMerchantTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 11. 29..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

/*
     회원 가맹점(쿠폰) 테이블 뷰
     - 현재 회원이 등록한 가맹점(쿠폰)을 보여주는 테이블 뷰 컨트롤러
 */
class UserMerchantTableViewController: UITableViewController {
    var userCouponList:[UserCouponModel?]? // 회원 쿠폰 정보
    lazy var singleton:CouponSignleton = {  // 쿠폰 싱글톤
        return CouponSignleton.sharedInstance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    // MARK: - 유저 쿠폰 리스트 가져오기
    func setData() {
        let userId = CouponSignleton.sharedInstance.userData?.id
        CouponNetwork.requestUserCouponData(userId: userId!, complete: { isSuccessed, userCouponList in
            if isSuccessed {
                self.userCouponList = userCouponList
                if self.userCouponList != nil {
                    self.tableView.reloadData()
                } else {
                    self.setData()
                }
            } else{
                self.setData()
            }
        })
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.userCouponList == nil {
            return 0
        } else {
            return self.userCouponList!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMerchantTableViewCell", for: indexPath) as! UserMerchantTableViewCell
        let userCouponModel = self.userCouponList?[indexPath.row]
        let merchantModel =  singleton.findMerchantModel(merchantId: userCouponModel?.merchantId)
        cell.merchantName.text = merchantModel?.name
        cell.logoImage.downloadedFrom(link:(merchantModel?.logoImageUrl)!)
        //cell.textLabel?.text = merchantModel?.name
        return cell
    }
    
    override func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCellEditingStyle, forRowAt indexPath:IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let userMerchantModel = userCouponList?[indexPath.row]
            if(deleteCoupon(merchantId:userMerchantModel?.merchantId)) {
                userCouponList?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
    }
 
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // CouponListViewController -> 데이터 전달
        if segue.identifier == "showCouponListView" {
            let couponListView:CouponListViewController? = segue.destination as? CouponListViewController
            couponListView?.userMerchantData = self.userCouponList?[(self.tableView.indexPathForSelectedRow?.row)!]
            couponListView?.merchantData = singleton.findMerchantModel(merchantId:couponListView?.userMerchantData?.merchantId)
        }
    }
    
    @IBAction func unwindToUserMercahntTableView(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindUserMerchant" {
        }
    }
    
    // MARK - ETC
    //삭제하기
    func deleteCoupon(merchantId:Int?) -> Bool {
        let deleteCouponFailTitle = NSLocalizedString("deleteCouponFailTitle", comment: "")
        let deleteCouponFailContent = NSLocalizedString("deleteCouponFailContent", comment: "")
        let userId = CouponSignleton.sharedInstance.userData?.id
        var state = false
        CouponNetwork.requestDeleteUserCoupon(userId: userId!, merchantId: merchantId!, complete: { isSuccessed in
            if isSuccessed {
               state = isSuccessed
            } else {
                CouponSignleton.showCustomPopup(title: deleteCouponFailTitle, message: deleteCouponFailContent,callback: nil)
                state = false
            }
        })
        return state
    }
}
