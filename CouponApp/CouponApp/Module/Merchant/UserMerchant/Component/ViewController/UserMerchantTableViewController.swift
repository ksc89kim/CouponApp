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
import Kingfisher
import RxDataSources


/// 회원 가맹점(쿠폰) 테이블 뷰
/// - 현재 회원이 등록한 가맹점(쿠폰)을 보여주는 테이블 뷰 컨트롤러
final class UserMerchantTableViewController : UITableViewController, Bindable {

  // MARK: - Define

  private enum Metric {
    static let contentInset: UIEdgeInsets = .init(top: 15, left: 0, bottom: 10, right: 0)
  }

  // MARK: - Property

  var merchantList: (any MerchantListable)?
  @Inject(UserMerchantViewModelKey.self)
  var viewModel: UserMerchantViewModelType
  /// 회원 쿠폰 정보
  private var userCouponList: (any UserCouponListable)?
  var disposeBag = DisposeBag()
  private let dataSource = RxTableViewSectionedReloadDataSource<UserMerchantSection>(
    configureCell: { _, tableView, indexPath, item -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CouponIdentifier.merchantTableViewCell.rawValue,
        for: indexPath
      ) as! MerchantTableViewCell

      cell.setMerchant(item)
      return cell
    }
  )

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

  // MARK: - Set Method

  private func setUI() {
    self.tableView.contentInset = Metric.contentInset
    let nib = UINib(type: .merchantTableViewCell)
    self.tableView.register(nib, forCellReuseIdentifier: CouponIdentifier.merchantTableViewCell.rawValue)
  }

  // MARK: - Bind

  func bindInputs() {
    self.tableView.rx.modelSelected(MerchantType.self)
      .subscribe(self.viewModel.inputs.showCouponListViewController)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemDeleted
      .subscribe(self.viewModel.inputs.deleteCoupon)
      .disposed(by: self.disposeBag)
  }

  func bindOutputs() {
    self.tableView.dataSource = nil

    self.viewModel.outputs?.reloadSections
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.updateCouponToDelete
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] sections, indexPath in
        self?.dataSource.setSections(sections)
        self?.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
      })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.showCustomPopup
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showCustomPopup)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.showCouponListViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] couponInfo in
        self?.performSegue(withIdentifier: CouponIdentifier.showCouponListView.rawValue, sender: couponInfo)
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    // CouponListViewController -> 데이터 전달
    if segue.identifier == CouponIdentifier.showCouponListView.rawValue,
       let viewController = segue.destination as? CouponListViewController,
       let couponInfo = sender as? CouponInfoType {
      viewController.viewModel.inputs.loadCoupon.onNext(couponInfo)
    }
  }

  @IBAction func unwindToUserMercahntTableView(segue: UIStoryboardSegue) {
  }
}
