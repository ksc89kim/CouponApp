//
//  AreasTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 1..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     전체 가맹점 테이블 뷰 컨트롤러
 */
class AreasTableViewController: UITableViewController  {
    lazy var merchantList:MerchantListModel? = {
        return CouponSignleton.instance.merchantList
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUI() {
        self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
        let nib = UINib(nibName: CouponNibName.merchantTableViewCell.rawValue, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier:CouponIdentifier.merchantTableViewCell.rawValue)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let model = merchantList else {
            return 0
        }
        return model.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponIdentifier.merchantTableViewCell.rawValue, for: indexPath) as! MerchantTableViewCell
        cell.setData(data: merchantList?[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell:MerchantTableViewCell = tableView.cellForRow(at: indexPath) as? MerchantTableViewCell  else {
            return
        }
        
        let customPopupViewController:MerchantInfoViewController = MerchantInfoViewController(nibName: CouponNibName.merchantInfoViewController.rawValue, bundle: nil)
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            var merchantInfoModel = customPopupViewController.merchantInfoModel
            merchantInfoModel.merchantModel = cell.model
            merchantInfoModel.cellTopView = cell.topView
            merchantInfoModel.cellTopLogoImage = cell.logoImageView.image ?? UIImage()
            merchantInfoModel.positionY = cell.frame.origin.y - (tableView.contentOffset.y) + 86
            customPopupViewController.merchantInfoModel = merchantInfoModel
            customPopupViewController.view.frame = window.frame

            window.addSubview(customPopupViewController.view)
            self.addChildViewController(customPopupViewController)
            customPopupViewController.didMove(toParentViewController: self)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
