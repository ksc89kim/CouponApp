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
    
    lazy var merchantList:MerchantListModel? = {
        return CouponSignleton.instance.merchantList
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        nearMerchantModelList = []
        
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI() {
        self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
        let nib = UINib(nibName: "MerchantTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier:"MerchantTableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantTableViewCell", for: indexPath) as! MerchantTableViewCell
        let merchantModel =  nearMerchantModelList![indexPath.row]
        cell.titleLabel.text = merchantModel?.name
        cell.topView.backgroundColor = UIColor.hexStringToUIColor(hex: (merchantModel?.cardBackGround)!)
        cell.logoImageView.downloadedFrom(link:(merchantModel?.logoImageUrl)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell:MerchantTableViewCell = tableView.cellForRow(at: indexPath) as? MerchantTableViewCell  else {
            return
        }
        
        guard let model:MerchantModel = merchantList?[indexPath.row] else {
            return
        }
        
        let customPopupViewController:MerchantInfoViewController = MerchantInfoViewController(nibName: "MerchantInfoViewController", bundle: nil)
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            let positionY = cell.frame.origin.y - (tableView.contentOffset.y) + 86
            customPopupViewController.merchantInfoModel.setData(model: model, topView: cell.topView, animationY: positionY)
            customPopupViewController.view.frame = window.frame
            customPopupViewController.setHeaderImageView(image: cell.logoImageView.image ?? UIImage())
            
            window.addSubview(customPopupViewController.view)
            self.addChildViewController(customPopupViewController)
            customPopupViewController.didMove(toParentViewController: self)
        }
    }

    // MARK: - CLLocation delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coor = manager.location?.coordinate {
            nearMerchantModelList?.removeAll()
            let currentLocation = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            
            for i in 0 ..< (merchantList?.list.count)! {
                guard let merchantModel = merchantList?[i] else {
                    return
                }
                let tempLocation = CLLocation(latitude: merchantModel.latitude, longitude: merchantModel.longitude)
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
 
    }
}
