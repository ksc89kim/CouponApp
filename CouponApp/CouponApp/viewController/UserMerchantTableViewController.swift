//
//  UserMerchantTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 11. 29..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

class UserMerchantTableViewController: UITableViewController {
    var userMerchantList:[UserMerchantModel?]?
    var merchantList:[MerchantModel?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user1 = UserMerchantModel()
        user1.merchantId = 1
        user1.couponCount = 10
        let user2 = UserMerchantModel()
        user2.merchantId = 1
        user2.couponCount = 20
        self.userMerchantList = [user1,user2]
        let merchant = MerchantModel()
        merchant.maxCouponCount = 30
        merchant.merchantId = 1
        merchant.name = "커피샾1"
        self.merchantList = [merchant]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userMerchantList!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let userMerchantModel = self.userMerchantList?[indexPath.row]
        let merchantModel = findMerchantModel(merchantId: userMerchantModel?.merchantId)
        cell.textLabel?.text = merchantModel?.name
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     // MARK: -
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
}
