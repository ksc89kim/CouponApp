//
//  UserMerchantTableViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/12/20.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class UserMerchantTableViewModel: ViewModel {

  struct Inputs {
    let loadData = PublishSubject<Void>()
    let deleteCoupon = PublishSubject<(merchantId: Int, indexPath: IndexPath)>()
  }

  struct Outputs {
    let reload = PublishSubject<UserCouponList>()
    let delete = PublishSubject<IndexPath>()
    let showCustomPopup = PublishSubject<CustomPopup>()
  }

  struct BindInputs {
    let reload: Observable<UserCouponList>
    let delete: Observable<IndexPath>
    let showCustomPopup: Observable<CustomPopup>
  }

  enum Text {
    static let deleteCouponFailTitle = "deleteCouponFailTitle"
    static let deleteCouponFailContent = "deleteCouponFailContent"
  }

  // MARK: - Properties

  let inputs = Inputs()
  let outputs = Outputs()
  private let disposeBag = DisposeBag()

  // MARK: - Init

  init() {
    let loadedData = self.loadData()
    let reload = self.reload(loadedData: loadedData)

    let deleteCoupon = self.deleteCoupon()
    let delete = self.delete(
      reload: reload,
      deleteCoupon: deleteCoupon
    )

    let showCustomPopup = self.showCustomPopup(
      deleteCoupon: deleteCoupon
    )

    self.bind(
      inputs: .init(
        reload: reload,
        delete: delete,
        showCustomPopup: showCustomPopup
      )
    )
  }

  func bind(inputs: BindInputs) {
    inputs.reload
      .bind(to: self.outputs.reload)
      .disposed(by: self.disposeBag)

    inputs.delete
      .bind(to: self.outputs.delete)
      .disposed(by: self.disposeBag)

    inputs.showCustomPopup
      .bind(to: self.outputs.showCustomPopup)
      .disposed(by: self.disposeBag)
  }

  private func loadData() -> Observable<(isSuccessed: Bool, list: UserCouponList?)> {
    return self.inputs.loadData
      .flatMapLatest { _ -> Observable<(isSuccessed: Bool, list: UserCouponList?)> in
        return RxCouponData.loadUserCouponData(userId: CouponSignleton.getUserId())
          .asObservable()
          .map { (isSuccessed: $0.0, list: $0.1) }
      }
  }

  private func reload(
    loadedData: Observable<(isSuccessed: Bool, list: UserCouponList?)>
  ) -> Observable<UserCouponList> {
    return loadedData
      .filter{ $0.isSuccessed }
      .map { $0.list }
      .filterNil()
      .share()
  }

  private func deleteCoupon() -> Observable<(isSuccessed: Bool, indexPath: IndexPath)> {
    return self.inputs.deleteCoupon
      .flatMapLatest { merchantId, indexPath -> Observable<(isSuccessed: Bool, indexPath: IndexPath)> in
        RxCouponData.deleteUserCoupon(
        userId: CouponSignleton.getUserId(), merchantId: merchantId
        )
        .asObservable()
        .map { (isSuccessed: $0, indexPath: indexPath) }
      }
      .share()
  }

  private func delete(
    reload: Observable<UserCouponList>,
    deleteCoupon: Observable<(isSuccessed: Bool, indexPath: IndexPath)>
  ) -> Observable<IndexPath> {
    return deleteCoupon
      .filter { $0.isSuccessed }
      .withLatestFrom(reload) { (list: $1, indexPath: $0.indexPath) }
      .do(onNext: { list, indexPath in
        var list = list
        list.remove(indexPath.row)
      })
      .map { $0.indexPath }
  }

  private func showCustomPopup(
    deleteCoupon: Observable<(isSuccessed: Bool, indexPath: IndexPath)>
  ) -> Observable<CustomPopup> {
    return deleteCoupon
      .filter { !$0.isSuccessed }
      .map { _ in
        return CustomPopup(
          title: Text.deleteCouponFailTitle,
          message: Text.deleteCouponFailContent,
          callback: nil
        )
      }
  }
}
