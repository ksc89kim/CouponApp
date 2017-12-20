//
//  UserMerchantTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 11. 29..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

class UserMerchantTableViewController: UITableViewController {
    var userCouponList:[UserCouponModel?]?
    var merchantList:[MerchantModel?]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - 가맹점 데이터 찾기
    func findMerchantModel(merchantId:Int?) -> MerchantModel? {
        var fMerchantModel:MerchantModel? = nil;
        for merchantModel in merchantList! {
            if merchantModel?.merchantId == merchantId {
                fMerchantModel = merchantModel
                break;
            }
        }
        return fMerchantModel
    }
    
    // MARK: - 가맹점 리스트, 유저 쿠폰 리스트 가져오기
    func setData() {
        do {
            self.userCouponList = try SQLInterface().selectUserCouponData(1)
            self.merchantList = try SQLInterface().selectMerchantData()
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userCouponList!.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! UserMerchantTableViewCell
        let userCouponModel = self.userCouponList?[indexPath.row]
        let merchantModel = findMerchantModel(merchantId: userCouponModel?.merchantId)
        cell.merchantName.text = merchantModel?.name
        //cell.textLabel?.text = merchantModel?.name
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // CouponListViewController -> 데이터 전달 (회원 쿠폰,
        if segue.identifier == "showCouponListView" {
            let couponListView:CouponListViewController? = segue.destination as? CouponListViewController
            couponListView?.userMerchantData = self.userCouponList?[(self.tableView.indexPathForSelectedRow?.row)!]
            couponListView?.merchantData = findMerchantModel(merchantId:couponListView?.userMerchantData?.merchantId)
        }
    }
    
    @IBAction func unwindToUserMercahntTableView(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindUserMerchant" {
            setData()
            self.tableView.reloadData()
        }
    }
}
