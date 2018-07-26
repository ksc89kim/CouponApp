//
//  NearMerchantTableViewController.swift
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
class NearMerchantTableViewController: UITableViewController , CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var nearMerchantModelList:[MerchantModel?]?
    
    lazy var singleton:CouponSignleton = {
        return CouponSignleton.instance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        nearMerchantModelList = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (nearMerchantModelList?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearMerchantTableViewCell", for: indexPath) as! NearMerchantTableViewCell
        let merchantModel =  nearMerchantModelList![indexPath.row]
        cell.merchantName.text = merchantModel?.name
        cell.logoImage.downloadedFrom(link:(merchantModel?.logoImageUrl)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    // MARK: - CLLocation delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate {
            nearMerchantModelList?.removeAll()
            let currentLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            for merchantModel in singleton.merchantList! {
                let tempLocation = CLLocation(latitude: (merchantModel?.latitude)!, longitude: (merchantModel?.longitude)!)
                let diffDistance = currentLocation.distance(from: tempLocation)
                if  diffDistance < 1000 { // 주변 가맹점인지 여부
                    nearMerchantModelList?.append(merchantModel)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMerchantView2" {
            let detailMerchantView:DetailMerchantViewController? = segue.destination as? DetailMerchantViewController
            let merchantModel = nearMerchantModelList![(self.tableView.indexPathForSelectedRow?.row)!]
            detailMerchantView?.merchantModel = merchantModel
        }
    }
}
