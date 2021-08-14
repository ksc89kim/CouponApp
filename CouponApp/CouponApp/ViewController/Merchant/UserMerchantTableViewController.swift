//
//  UserTableViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 11. 29..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 회원 가맹점(쿠폰) 테이블 뷰
/// - 현재 회원이 등록한 가맹점(쿠폰)을 보여주는 테이블 뷰 컨트롤러
final class UserMerchantTableViewController : UITableViewController, BaseBind {

  // MARK: - Property

  var merchantList: MerchantImplList? {
    return CouponSignleton.instance.merchantList
  }

  let viewModel = UserMerchantViewModel()
  var userCouponList: UserCouponList? // 회원 쿠폰 정보
  var disposeBag = DisposeBag()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
    self.bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel.inputs.loadData.onNext(())
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Set Function

  private func setUI() {
    self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
    let nib = UINib(nibName: CouponNibName.merchantTableViewCell.rawValue, bundle: nil)
    self.tableView.register(nib, forCellReuseIdentifier: CouponIdentifier.merchantTableViewCell.rawValue)
  }

  // MARK: - Bind

  func bindInputs() {
    
  }

  func bindOutputs() {
    self.viewModel.outputs?.reload
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] list in
        self?.userCouponList = list
        self?.tableView.reloadData()
      })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.delete
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] indexPath in
        self?.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
      })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.showCustomPopup
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showCustomPopup)
      .disposed(by: self.disposeBag)
  }

  // MARK: - TableView Delegate & DataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let couponList = self.userCouponList else {
      return 0
    }
    return couponList.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: CouponIdentifier.merchantTableViewCell.rawValue,
      for: indexPath
    ) as! MerchantTableViewCell

    let userCoupon = self.userCouponList?[indexPath.row]
    if let merchant = self.merchantList?.index(merchantId: userCoupon?.merchantId) {
      cell.titleLabel.text = merchant.name
      cell.topView.backgroundColor = UIColor.hexStringToUIColor(hex: merchant.cardBackGround)
      cell.logoImageView.downloadedFrom(link: merchant.logoImageUrl)
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: CouponIdentifier.showCouponListView.rawValue, sender: indexPath)
  }

  override func tableView(
    _ tableView:UITableView,
    commit editingStyle:UITableViewCellEditingStyle,
    forRowAt indexPath:IndexPath
  ) {
    if editingStyle == UITableViewCellEditingStyle.delete,
       let merchant = self.userCouponList?[indexPath.row] {
      self.viewModel.inputs.deleteCoupon.onNext((merchantId: merchant.merchantId, indexPath: indexPath))
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    // CouponListViewController -> 데이터 전달
    if segue.identifier == CouponIdentifier.showCouponListView.rawValue,
       let couponListView = segue.destination as? CouponListViewController,
       let indexPath = sender as? IndexPath {
      couponListView.userCouponData = self.userCouponList?[indexPath.row]
      couponListView.merchantData = self.merchantList?.index(
        merchantId:couponListView.userCouponData?.merchantId
      )
    }
  }

  @IBAction func unwindToUserMercahntTableView(segue: UIStoryboardSegue) {
  }
}
