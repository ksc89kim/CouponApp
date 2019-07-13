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
        guard let model:MerchantModel = merchantList?[indexPath.row] else {
            return cell
        }
        
        cell.titleLabel.text = model.name
        cell.topView.backgroundColor = UIColor.hexStringToUIColor(hex: model.cardBackGround)
        cell.topView.isHidden = false
        cell.logoImageView.downloadedFrom(link:model.logoImageUrl)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell:MerchantTableViewCell = tableView.cellForRow(at: indexPath) as? MerchantTableViewCell  else {
            return
        }
        
        guard let model:MerchantModel = merchantList?[indexPath.row] else {
            return
        }
        
        let customPopupViewController:MerchantInfoViewController = MerchantInfoViewController(nibName: CouponNibName.merchantInfoViewController.rawValue, bundle: nil)
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            let positionY = cell.frame.origin.y - (tableView.contentOffset.y) + 86
            customPopupViewController.merchantInfoModel.setData(model: model, topView: cell.topView, animationY: positionY)
            customPopupViewController.view.frame = window.frame
            customPopupViewController.setHeaderImageView(image: cell.logoImageView.image ?? UIImage())
            
            window.addSubview(customPopupViewController.view)
            self.addChildViewController(customPopupViewController)
            customPopupViewController.didMove(toParentViewController: self)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
