//
//  AroundTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 2..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import CoreLocation

/// 주변 가맹점 테이블 뷰 컨트롤러
final class AroundMerchantTableViewController: MerchantTableViewController  {

  // MARK: - Define

  enum Metric {
    static let contentInset: UIEdgeInsets = .init(top: 15, left: 0, bottom: 10, right: 0)
  }

  // MARK: - Property

  private var locationManager: CLLocationManager!
  private var merchantArray: [MerchantImpl?]?
  fileprivate let maxDistance: Double = 1000

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.merchantArray = []
    self.setUI()
    self.setLocationManager()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Set Method

  private func setUI() {
    self.tableView.contentInset = Metric.contentInset
    let nib = UINib(type: .merchantTableViewCell)
    self.tableView.register(nib, forCellReuseIdentifier:CouponIdentifier.merchantTableViewCell.rawValue)
  }

  private func setLocationManager() {
    self.locationManager = CLLocationManager()
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.startUpdatingLocation()
  }

  // MARK: - TableView DataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.merchantArray?.count)!
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CouponIdentifier.merchantTableViewCell.rawValue, for: indexPath) as! MerchantTableViewCell
    cell.setMerchant(self.merchantArray![indexPath.row])
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


extension AroundMerchantTableViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let merchantList = CouponSignleton.instance.merchantList else {
      print("merchantList nil")
      return
    }

    guard let coor = manager.location?.coordinate else {
      print("coordinate nil")
      return
    }

    self.merchantArray?.removeAll()
    let currentLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)

    for i in 0 ..< merchantList.count {
      guard let merchant = merchantList[i] else {
        continue
      }

      let tempLocation = CLLocation(latitude: merchant.latitude, longitude: merchant.longitude)
      let diffDistance = currentLocation.distance(from: tempLocation)
      if  diffDistance < self.maxDistance {
        self.merchantArray?.append(merchant)
      }
    }

    self.tableView.reloadData()
  }
}
