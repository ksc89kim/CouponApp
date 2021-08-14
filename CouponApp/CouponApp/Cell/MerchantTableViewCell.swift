//
//  MerchantTableViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 2. 9..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

final class MerchantTableViewCell: UITableViewCell {

  // MARK: -  UI Component

  @IBOutlet weak var backGroundView: UIView!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var lineView: UIView!
  @IBOutlet weak var grayLineView: UIView!
  @IBOutlet weak var titleLabel: UILabel!

  // MARK: -  Property

  let headerTopHeight: CGFloat = 86
  private let dashLineLayer = CAShapeLayer()
  weak var merchant: MerchantImpl?

  // MARK: -  Deinit

  deinit {
    self.lineView.layer.removeObserver(self, forKeyPath: "bounds")
  }

  // MARK: -  Life Cycle

  override func awakeFromNib() {
    super.awakeFromNib()
    self.setUI()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  // MARK: - Set Function

  private func setUI() {
    self.backGroundView.layer.cornerRadius = 5
    self.backGroundView.layer.shadowOpacity = 0.18
    self.backGroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.backGroundView.layer.shadowRadius = 2
    self.backGroundView.layer.shadowColor = UIColor.black.cgColor
    self.backGroundView.layer.masksToBounds = false

    self.topView.layer.cornerRadius = 5
    if #available(iOS 11.0, *) {
      self.topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    self.logoImageView.layer.cornerRadius = self.logoImageView.bounds.width/2
    self.grayLineView.layer.cornerRadius = 5

    self.lineView.addDashLine(dashLayer: self.dashLineLayer,color: UIColor.white, lineWidth: 3)
    self.lineView.layer.addObserver(self, forKeyPath:"bounds", options:.new, context: nil)
  }

  func setData(data: MerchantImpl?) {
    guard let merchant = data else {
      print("merchantModel nil")
      return
    }

    self.titleLabel.text = merchant.name
    self.topView.backgroundColor = UIColor.hexStringToUIColor(hex: merchant.cardBackGround)
    self.logoImageView.downloadedFrom(link:merchant.logoImageUrl)
    self.merchant = merchant
  }

  // MARK: -  Show Function

  func showDetail(parentViewController: UIViewController, tableView: UITableView) {
    let detailViewController = MerchantDetailViewController(nibName: CouponNibName.merchantDetailViewController.rawValue, bundle: nil)

    if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
      detailViewController.merchantDetail.setCellData(cell: self, offsetY: tableView.contentOffset.y)
      detailViewController.view.frame = window.frame

      window.addSubview(detailViewController.view)
      parentViewController.addChildViewController(detailViewController)
      detailViewController.didMove(toParentViewController: parentViewController)
    }
  }

  // MARK: -  Observe

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    if keyPath == "bounds" {
      self.lineView.updateDashLineSize(dashLayer: dashLineLayer)
    }
  }
}
