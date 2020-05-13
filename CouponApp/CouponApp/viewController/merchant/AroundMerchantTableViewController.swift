//
//  AroundTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 2..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import CoreLocation

/*
     주변 가맹점 테이블 뷰 컨트롤러
 */
class AroundMerchantTableViewController: UITableViewController , CLLocationManagerDelegate {
    private var locationManager:CLLocationManager!
    private var merchantArray:[MerchantImpl?]?
    private let maxDistance:Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        merchantArray = []
        setUI()
        setLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUI() {
        self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
        let nib = UINib(nibName: CouponNibName.merchantTableViewCell.rawValue, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier:CouponIdentifier.merchantTableViewCell.rawValue)
    }
    
    private func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (merchantArray?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponIdentifier.merchantTableViewCell.rawValue, for: indexPath) as! MerchantTableViewCell
        let merchant = merchantArray![indexPath.row]
        cell.setData(data: merchant)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell:MerchantTableViewCell = tableView.cellForRow(at: indexPath) as? MerchantTableViewCell  else {
            return
        }
        
        cell.showDetail(parentViewController: self, tableView: tableView)
    }

    // MARK: - CLLocation delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let merchantList = CouponSignleton.instance.merchantList else {
            print("merchantList nil")
            return
        }
        
        guard let coor = manager.location?.coordinate else {
            print("coordinate nil")
            return
        }
        
        merchantArray?.removeAll()
        let currentLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
        
        
        for i in 0 ..< merchantList.count {
            guard let merchant = merchantList[i] else {
                continue
            }
            
            let tempLocation = CLLocation(latitude: merchant.latitude, longitude: merchant.longitude)
            let diffDistance = currentLocation.distance(from: tempLocation)
            if  diffDistance < maxDistance { // 주변 가맹점인지 여부
                merchantArray?.append(merchant)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
    }
}
