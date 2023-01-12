//
//  MerchantTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2022/03/25.
//  Copyright © 2022 kim sunchul. All rights reserved.
//

import UIKit

class MerchantTableViewController: UITableViewController {
  
  // MARK: - Method

  func showMerchantDetail(selectedCell: MerchantTableViewCell) {
    guard let merchant = selectedCell.merchant else { return }

    let viewModel = MerchantDetailViewModel()
    let detailViewController = MerchantDetailViewController()
    detailViewController.viewModel = viewModel
    var cellTopViewFrame = selectedCell.topView.frame
    cellTopViewFrame.origin.y = selectedCell.frame.origin.y - self.tableView.contentOffset.y + MerchantTableViewCell.Metric.headerTopHeight

    viewModel.inputs.merchantDetail.onNext(
      .init(
        cellCornerRadius: selectedCell.topView.layer.cornerRadius,
        cellTopViewFrame: cellTopViewFrame,
        merchant: merchant
      )
    )
    self.present(detailViewController, animated: true, completion: nil)
  }
}
