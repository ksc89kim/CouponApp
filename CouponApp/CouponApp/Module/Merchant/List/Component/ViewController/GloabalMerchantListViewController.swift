//
//  GloabalMerchantListController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 1..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/// 전체 가맹점 테이블 뷰 컨트롤러
final class GloabalMerchantListViewController: MerchantListViewController {

  // MARK: - Define

  enum Metric {
    static let contentInset: UIEdgeInsets = .init(top: 15, left: 0, bottom: 10, right: 0)
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
}
