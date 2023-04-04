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
    let error = PublishSubject<Error>()
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

    let deleteCoupon = self.deleteCoupon(subject: subject)
    let delete = self.delete(
      loadedData: loadedData,
      deleteCoupon: deleteCoupon
    )

    let showCustomPopup = self.showCustomPopup(
      error: subject.error.asObservable()
    )

    self.outputs = UserMerchantOutputs(
      reload: loadedData,
      delete: delete,
      showCustomPopup: showCustomPopup
    )
  }

  // MARK: - Method

  private func loadData(subject: Subject) -> Observable<UserCouponList> {
    return subject.loadData
      .withLatestFrom(Me.instance.rx.userID)
      .flatMapLatest { id -> Observable<UserCouponList> in
        return CouponRepository.instance.rx.loadUserCouponData(userId: id)
          .asObservable()
          .suppressAndFeedError(into: subject.error)
          .compactMap { $0.data as? UserCouponList }
      }
      .share()
  }

  private func deleteCoupon(subject: Subject) -> Observable<IndexPath> {
    return subject.deleteCoupon
      .withLatestFrom(Me.instance.rx.userID) { value, id in
        return (value.merchantId, value.indexPath, id)
      }
      .flatMapLatest { merchantId, indexPath, id -> Observable<IndexPath> in
         return CouponRepository.instance.rx.deleteUserCoupon(userId: id, merchantId: merchantId)
        .asObservable()
        .suppressAndFeedError(into: subject.error)
        .map { _ in indexPath }
      }
      .share()
  }

  private func delete(
    loadedData: Observable<UserCouponList>,
    deleteCoupon: Observable<IndexPath>
  ) -> Observable<IndexPath> {
    return deleteCoupon
      .withLatestFrom(loadedData) { (list: $1, indexPath: $0) }
      .do(onNext: { list, indexPath in
        var list = list
        list.remove(indexPath.row)
      })
      .map { $0.indexPath }
  }

  private func showCustomPopup(error: Observable<Error>) -> Observable<CustomPopup> {
    return error
      .map { _ in
        return CustomPopup(
          title: Text.deleteCouponFailTitle,
          message: Text.deleteCouponFailContent,
          completion: nil
        )
      }
  }
}
