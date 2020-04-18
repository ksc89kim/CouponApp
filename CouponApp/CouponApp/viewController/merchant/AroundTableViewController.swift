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
class AroundTableViewController: UITableViewController , CLLocationManagerDelegate {
    private var locationManager:CLLocationManager!
    private var merchantModelArray:[MerchantModel?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        merchantModelArray = []
        setUI()
        setLocationManager()
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
    
    func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (merchantModelArray?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponIdentifier.merchantTableViewCell.rawValue, for: indexPath) as! MerchantTableViewCell
        let merchantModel = merchantModelArray![indexPath.row]
        cell.setData(data: merchantModel)
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

    // MARK: - CLLocation delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let merchantListModel = CouponSignleton.instance.merchantList else {
            print("merchantListModel nil")
            return
        }
        
        guard let coor = manager.location?.coordinate else {
            print("coordinate nil")
            return
        }
        
        merchantModelArray?.removeAll()
        let currentLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
        
        for i in 0 ..< merchantListModel.count {
            guard let merchantModel = merchantListModel[i] else {
                continue
            }
            
            let tempLocation = CLLocation(latitude: merchantModel.latitude, longitude: merchantModel.longitude)
            let diffDistance = currentLocation.distance(from: tempLocation)
            if  diffDistance < 1000 { // 주변 가맹점인지 여부
                merchantModelArray?.append(merchantModel)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
    }
}
