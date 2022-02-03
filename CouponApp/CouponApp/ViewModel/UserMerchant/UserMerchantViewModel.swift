//
//  UserMerchantViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/12/20.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class UserMerchantViewModel: UserMerchantViewModelType {

  // MARK: - Define

  private struct Subject {
    let loadData = PublishSubject<Void>()
    let deleteCoupon = PublishSubject<(merchantId: Int, indexPath: IndexPath)>()
  }

  enum Text {
    static let deleteCouponFailTitle = "deleteCouponFailTitle"
    static let deleteCouponFailContent = "deleteCouponFailContent"
  }

  // MARK: - Property

  var inputs: UserMerchantInputType { return self.userMerchantInputs }
  var outputs: UserMerchantOutputType? { return self.userMerchantOutputs }
  private let userMerchantInputs: UserMerchantInputs
  private var userMerchantOutputs: UserMerchantOutputs?

  // MARK: - Init

  init() {
    let subject = Subject()

    self.userMerchantInputs = .init(
      loadData: subject.loadData.asObserver(),
      deleteCoupon: subject.deleteCoupon.asObserver()
    )

    let loadedData = self.loadData(subject: subject)
    let reload = self.reload(loadedData: loadedData)

    let deleteCoupon = self.deleteCoupon(subject: subject)
    let delete = self.delete(
      reload: reload,
      deleteCoupon: deleteCoupon
    )

    let showCustomPopup = self.showCustomPopup(
      deleteCoupon: deleteCoupon
    )

    self.userMerchantOutputs = .init(
      reload: reload,
      delete: delete,
      showCustomPopup: showCustomPopup
    )
  }

  // MARK: - Function

  private func loadData(subject: Subject) -> Observable<(isSuccessed: Bool, list: UserCouponList?)> {
    return subject.loadData
      .flatMapLatest { _ -> Observable<(isSuccessed: Bool, list: UserCouponList?)> in
        return RxCouponRepository.loadUserCouponData(userId: CouponSignleton.getUserId())
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

  private func deleteCoupon(subject: Subject) -> Observable<(isSuccessed: Bool, indexPath: IndexPath)> {
    return subject.deleteCoupon
      .flatMapLatest { merchantId, indexPath -> Observable<(isSuccessed: Bool, indexPath: IndexPath)> in
         return RxCouponRepository.deleteUserCoupon(userId: CouponSignleton.getUserId(), merchantId: merchantId)
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

  private func showCustomPopup(deleteCoupon: Observable<(isSuccessed: Bool, indexPath: IndexPath)>) -> Observable<CustomPopup> {
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
