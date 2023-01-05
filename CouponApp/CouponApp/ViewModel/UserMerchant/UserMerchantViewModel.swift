//
//  UserMerchantViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/12/20.
//  Copyright © 2020 kim sunchul. All rights reserved.
//
import UIKit
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

  var inputs: UserMerchantInputType
  var outputs: UserMerchantOutputType?

  // MARK: - Init

  init() {
    let subject = Subject()

    self.inputs = UserMerchantInputs(
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

    self.outputs = UserMerchantOutputs(
      reload: reload,
      delete: delete,
      showCustomPopup: showCustomPopup
    )
  }

  // MARK: - Method

  private func loadData(subject: Subject) -> Observable<(isSuccessed: Bool, list: UserCouponList?)> {
    return subject.loadData
      .withLatestFrom(Me.instance.rx.userID)
      .flatMapLatest { id -> Observable<(isSuccessed: Bool, list: UserCouponList?)> in
        return CouponRepository.instance.rx.loadUserCouponData(userId: id)
          .asObservable()
          .map { (isSuccessed: $0.isSuccessed, list: $0.data as? UserCouponList) }
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
      .withLatestFrom(Me.instance.rx.userID) { value, id in
        return (value.merchantId, value.indexPath, id)
      }
      .flatMapLatest { merchantId, indexPath, id -> Observable<(isSuccessed: Bool, indexPath: IndexPath)> in
         return CouponRepository.instance.rx.deleteUserCoupon(userId: id, merchantId: merchantId)
        .asObservable()
        .map { (isSuccessed: $0.isSuccessed, indexPath: indexPath) }
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
          completion: nil
        )
      }
  }
}
