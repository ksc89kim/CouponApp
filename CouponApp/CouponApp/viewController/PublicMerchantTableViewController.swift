//
//  PublicMerchantTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 1..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     전체 가맹점 테이블 뷰 컨트롤러
 */
class PublicMerchantTableViewController: UITableViewController  {
    
    lazy var singleton:CouponSignleton = {
        return CouponSignleton.sharedInstance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return (singleton.merchantList?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicMerchantTableViewCell", for: indexPath) as! PublicMerchantTableViewCell
        let merchantModel =  singleton.merchantList![indexPath.row]
        cell.merchantName.text = merchantModel?.name
        cell.logoImage.downloadedFrom(link:(merchantModel?.logoImageUrl)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMerchantView1" {
            let detailMerchantView:DetailMerchantViewController? = segue.destination as? DetailMerchantViewController
            let merchantModel = singleton.merchantList![(self.tableView.indexPathForSelectedRow?.row)!]
            detailMerchantView?.merchantModel = merchantModel
        }
    }

}
