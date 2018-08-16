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
    
    lazy var merchantList:MerchantListModel? = {
        return CouponSignleton.instance.merchantList
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
        guard let model = merchantList else {
            return 0
        }
        return model.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicMerchantTableViewCell", for: indexPath) as! PublicMerchantTableViewCell
        guard let model:MerchantModel = merchantList?[indexPath.row] else {
            return cell
        }
        cell.merchantName.text = model.name
        cell.logoImage.downloadedFrom(link:model.logoImageUrl)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMerchantView1" {
            let detailMerchantView:DetailMerchantViewController? = segue.destination as? DetailMerchantViewController
            let merchantModel = merchantList?[(self.tableView.indexPathForSelectedRow?.row)!]
            detailMerchantView?.merchantModel = merchantModel
        }
    }

}
