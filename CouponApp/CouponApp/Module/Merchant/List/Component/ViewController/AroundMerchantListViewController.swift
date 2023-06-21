//
//  AroundMerchantListViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 2..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import CoreLocation

/// 주변 가맹점 테이블 뷰 컨트롤러
final class AroundMerchantListViewController: MerchantListViewController {

  // MARK: - Define

  enum Metric {
    static let contentInset: UIEdgeInsets = .init(top: 15, left: 0, bottom: 10, right: 0)
  }

  // MARK: - Property

  private var locationManager: CLLocationManager?

  // MARK: - Life Cycle

  override func viewDidLoad() {
    self.setLocationManager()
    super.viewDidLoad()

    self.setUI()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Set Method

  private func setUI() {
    self.tableView.contentInset = Metric.contentInset
    let nib = UINib(type: .merchantTableViewCell)
    self.tableView.register(nib, forCellReuseIdentifier: CouponIdentifier.merchantTableViewCell.rawValue)
  }

  private func setLocationManager() {
    self.locationManager = CLLocationManager()
    self.locationManager?.requestWhenInUseAuthorization()
    self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager?.startUpdatingLocation()
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()

    guard let inputs = self.viewModel?.inputs as? AroundMerchantListInputs else { return }

    self.locationManager?.rx.didUpdateLocationManager
      .subscribe(inputs.didUpdateLocation)
      .disposed(by: self.disposeBag)
  }
}
