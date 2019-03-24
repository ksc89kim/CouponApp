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
    var userCouponList:UserCouponListModel? // 회원 쿠폰 정보
    lazy var merchantList:MerchantListModel? = {
        return CouponSignleton.instance.merchantList
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI() {
        self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
        let nib = UINib(nibName: "MerchantTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier:"MerchantTableViewCell")
    }
    
    // MARK: - 유저 쿠폰 리스트 가져오기
    func setData() {
        let userId = CouponSignleton.instance.userData?.id
        CouponData.getUserCouponData(userId: userId!, complete: { [weak self] isSuccessed, userCouponList in
            if isSuccessed {
                self?.userCouponList = userCouponList
                if self?.userCouponList != nil {
                    self?.tableView.reloadData()
                }
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
        return 145
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantTableViewCell", for: indexPath) as! MerchantTableViewCell
        let userCouponModel = self.userCouponList?[indexPath.row]
        let merchantModel = merchantList?.index(merchantId: userCouponModel?.merchantId)
        cell.titleLabel.text = merchantModel?.name
        cell.topView.backgroundColor = UIColor.hexStringToUIColor(hex: (merchantModel?.cardBackGround)!)
        cell.logoImageView.downloadedFrom(link:(merchantModel?.logoImageUrl)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showCouponListView", sender: indexPath)
    }
    
    override func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCellEditingStyle, forRowAt indexPath:IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let userMerchantModel = userCouponList?[indexPath.row]
            if(deleteCoupon(merchantId:userMerchantModel?.merchantId)) {
                userCouponList?.remove(indexPath.row)
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
            let indexPath:IndexPath = sender as! IndexPath
            couponListView?.userMerchantData = self.userCouponList?[indexPath.row]
            couponListView?.merchantData = merchantList?.index(merchantId:couponListView?.userMerchantData?.merchantId)
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
        let userId = CouponSignleton.instance.userData?.id
        var state = false
        CouponData.deleteUserCoupon(userId: userId!, merchantId: merchantId!, complete: { [weak self] isSuccessed in
            if isSuccessed {
               state = isSuccessed
            } else {
                self?.showCustomPopup(title: deleteCouponFailTitle, message: deleteCouponFailContent)
                state = false
            }
        })
        return state
    }
}
