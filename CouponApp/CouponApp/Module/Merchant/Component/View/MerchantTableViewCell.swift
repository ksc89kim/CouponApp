//
//  MerchantTableViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 2. 9..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit
import Kingfisher

final class MerchantTableViewCell: UITableViewCell {

  // MARK: - Define

  enum Metric {
    static let headerTopHeight: CGFloat = 81.5
    static let cornerRadius: CGFloat = 5
    static let lineWidth: CGFloat = 3
    static let shadowOffset: CGSize = .init(width: 0, height: 2)
    static let shadowRadius: CGFloat = 2
  }

  // MARK: - UI Component

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var lineView: UIView!
  @IBOutlet weak var grayLineView: UIView!
  @IBOutlet weak var titleLabel: UILabel!

  // MARK: - Property

  private let dashLineLayer = CAShapeLayer()
  var merchant: Merchant?

  // MARK: - Deinit

  deinit {
    self.lineView.layer.removeObserver(self, forKeyPath: "bounds")
  }

  // MARK: - Life Cycle

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

  // MARK: - Set Method

  private func setUI() {
    self.containerView.layer.cornerRadius = Metric.cornerRadius
    self.containerView.layer.shadowOpacity = 0.18
    self.containerView.layer.shadowOffset = Metric.shadowOffset
    self.containerView.layer.shadowRadius = Metric.shadowRadius
    self.containerView.layer.shadowColor = UIColor.black.cgColor
    self.containerView.layer.masksToBounds = false

    self.topView.layer.cornerRadius = Metric.cornerRadius
    self.topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    self.logoImageView.layer.cornerRadius = self.logoImageView.bounds.width / 2
    self.grayLineView.layer.cornerRadius = Metric.cornerRadius

    self.lineView.addDashLine(dashLayer: self.dashLineLayer,color: UIColor.white, lineWidth: Metric.lineWidth)
    self.lineView.layer.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
  }

  func setMerchant(_ Merchant: Merchant?) {
    guard let merchant = Merchant else {
      print("merchantModel nil")
      return
    }

    self.titleLabel.text = merchant.name
    self.topView.backgroundColor = UIColor.hexStringToUIColor(hex: merchant.cardBackGround)
    self.logoImageView.kf.setImage(with: merchant.logoImageUrl)
    self.merchant = merchant
  }

  // MARK: -  Observe

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    if keyPath == "bounds" {
      self.lineView.updateDashLineSize(dashLayer: self.dashLineLayer)
    }
  }
}
