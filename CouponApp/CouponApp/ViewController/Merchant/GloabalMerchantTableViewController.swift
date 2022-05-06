//
//  AreasTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 1..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/// 전체 가맹점 테이블 뷰 컨트롤러
final class GloabalMerchantTableViewController: MerchantTableViewController {

  // MARK: - Define

  enum Metric {
    static let contentInset: UIEdgeInsets = .init(top: 15, left: 0, bottom: 10, right: 0)
  }

  // MARK: - Property

  var merchantList: MerchantImplList? {
    return CouponSignleton.instance.merchantList
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Set Methods

  func setUI() {
    self.tableView.contentInset = Metric.contentInset
    let nib = UINib(type: .merchantTableViewCell)
    self.tableView.register(nib, forCellReuseIdentifier: CouponIdentifier.merchantTableViewCell.rawValue)
  }

  // MARK: - TableView DataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    guard let merchantArray = merchantList else {
      return 0
    }
    return merchantArray.list.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CouponIdentifier.merchantTableViewCell.rawValue, for: indexPath) as! MerchantTableViewCell
    cell.setMerchant(merchantList?[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell: MerchantTableViewCell = tableView.cellForRow(at: indexPath) as? MerchantTableViewCell  else {
      return
    }

    self.showMerchantDetail(selectedCell: cell)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  }
}
