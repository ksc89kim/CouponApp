//
//  CouponListViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 8. 15..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/// 쿠폰 리스트 뷰 컨트롤러
/// - 현재 가지고 있는 쿠폰 갯수와, 채울 수 있는 최대 쿠폰 갯수를 보여주는 뷰 컨트롤러
/// - 쿠폰 소진하기 및 쿠폰 요청하기 기능이 있음.
final class CouponListViewController: BaseViewController {

  // MARK: - Define

  private enum Metric {
    static let cellSize = CGSize(width: 50 , height: 50)
    static let sectionInset: UIEdgeInsets = .zero
    static let minimumLineSpacing: CGFloat = 5.0
    static let minimumInteritemSpacing: CGFloat = 5.0
    static let bottomButtonRoundedViewBorder: CGFloat = 1.0
    static let backgroundViewBorder: CGFloat = 1.0
    static let backgroundViewCornerRadius: CGFloat = 10.0
    static let holeViewBorder: CGFloat = 1.0
    static let lineWidth: CGFloat = 2.0
  }

  // MARK: - UI Component

  private lazy var flowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = Metric.cellSize
    layout.sectionInset = Metric.sectionInset
    layout.minimumLineSpacing = Metric.minimumLineSpacing
    layout.minimumInteritemSpacing = Metric.minimumInteritemSpacing
    return layout
  }()

  @IBOutlet weak var myCollectionView: UICollectionView!
  @IBOutlet weak var backgroundRoundedView: UIView!
  @IBOutlet weak var bottomButtonRoundedView: UIView!
  @IBOutlet weak var dotLineView: UIView!
  @IBOutlet weak var leftHoleView: UIView!
  @IBOutlet weak var rightHoleView: UIView!
  @IBOutlet weak var requestButton: UIButton!
  @IBOutlet weak var useButton: UIButton!

  // MARK: - Property

  private let viewModel = CouponListViewModel()
  private var selectedCouponIndex: Int = 0
  private let dashLineLayer = CAShapeLayer()
  var userCoupon: UserCoupon?
  var merchant: Merchant?

  // MARK: - Deinit

  deinit {
    self.dotLineView.layer.removeObserver(self, forKeyPath:"bounds")
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    if let userCoupon = self.userCoupon, let merchant = self.merchant {
      self.viewModel.inputs.loadCoupon.onNext(.init(userCoupon: userCoupon, merchant: merchant))
    }
    self.setUI()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()

    self.requestButton.rx.tap
      .bind(to: self.viewModel.inputs.onAddCoupon)
      .disposed(by: self.disposeBag)

    self.useButton.rx.tap
      .bind(to: self.viewModel.inputs.onUseCoupon)
      .disposed(by: self.disposeBag)
  }

  override func bindOutputs() {
    super.bindOutputs()

    self.viewModel.outputs?.navigationTitle
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.navigationItem.rx.title)
      .disposed(by: self.disposeBag)
    
    self.viewModel.outputs?.showCustomPopup
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showCustomPopup)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.reload
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.reload)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.selectedCouponIndex
      .subscribe(onNext: { [weak self] (index: Int) in
        self?.selectedCouponIndex = index
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Set Method

  private func setUI() {
    self.setBackgroundRoundedView(view: self.backgroundRoundedView)
    self.setHoleView(view: self.leftHoleView)
    self.setHoleView(view: self.rightHoleView)
    self.setBottomButtonRoundedView()
    self.setCollectionView()
    self.addDashLineAndObserver()
  }

  private func setBottomButtonRoundedView() {
    self.bottomButtonRoundedView.layer.borderWidth = Metric.bottomButtonRoundedViewBorder
    self.bottomButtonRoundedView.layer.borderColor = UIColor.couponGrayColor2.cgColor
  }

  private func setBackgroundRoundedView(view: UIView) {
    view.layer.borderWidth = Metric.backgroundViewBorder
    view.layer.borderColor = UIColor.couponGrayColor1.cgColor
    view.layer.cornerRadius = Metric.backgroundViewCornerRadius
  }

  private func setHoleView(view: UIView) {
    view.layer.borderWidth = Metric.holeViewBorder
    view.layer.borderColor = UIColor.couponGrayColor1.cgColor
    view.layer.cornerRadius = view.frame.size.width / 2
  }

  private func setCollectionView() {
    self.myCollectionView.setCollectionViewLayout(self.flowLayout, animated: true)
    self.myCollectionView.reloadData()
  }

  // MARK: - Add Method

  private func addDashLineAndObserver() {
    self.dotLineView.addDashLine(
      dashLayer: self.dashLineLayer,
      color: UIColor.couponGrayColor1,
      lineWidth: Metric.lineWidth
    )

    self.dotLineView.layer.addObserver(
      self,
      forKeyPath: "bounds",
      options: .new,
      context: nil
    )
  }

  // MARK: - Observe

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?, change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    if keyPath == "bounds" {
      self.dotLineView.updateDashLineSize(dashLayer: dashLineLayer)
    }
  }
}


extension CouponListViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let merchant = self.merchant else {
      print("collectionView - merchantData error")
      return 0
    }
    return merchant.couponCount()
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath) as! CouponCollectionViewCell

    guard let merchant = self.merchant, let couponCount = self.userCoupon?.couponCount else  {
      print("collectionView - merchantData error,  couponCount error")
      return cell
    }

    var coupon: CouponUIType = merchant.index(indexPath.row)
    coupon.isUseCoupon = (indexPath.row < couponCount)
    coupon.isAnimation = (indexPath.row == self.selectedCouponIndex)
    cell.updateUI(coupon: coupon)

    return cell
  }
}


extension Reactive where Base: CouponListViewController {
  var reload: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.myCollectionView.reloadData()
    }
  }
}
