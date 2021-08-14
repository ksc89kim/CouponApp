//
//  MerchantDetailViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/01/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class MerchantDetailViewModel: MerchantDetailViewModelType {

  // MARK: - Define

  private struct Subject {
    let loadData = PublishSubject<MerchantDetail>()
    let actionFromBottom = PublishSubject<Void>()
  }

  private enum Text {
    static let insert = "추가하기"
    static let delete = "삭제하기"
    static let insertCouponFailTitle = "insertCouponFailTitle"
    static let insertCouponFailContent = "insertCouponFailContent"
    static let insertCouponSuccessTitle = "insertCouponSuccessTitle"
    static let insertCouponSuccessContent = "insertCouponSuccessContent"
    static let deleteCouponFailTitle = "deleteCouponFailTitle"
    static let deleteCouponFailContent = "deleteCouponFailContent"
    static let deleteCouponSuccessTitle = "deleteCouponSuccessTitle"
    static let deleteCouponSuccessContent = "deleteCouponSuccessContent"
  }

  //MARK: - Property

  var inputs: MerchantDetailInputType { return self.merchantDetailInputs }
  var outputs: MerchantDetailOutputType? { return self.merchantDetailOutputs }
  private let merchantDetailInputs: MerchantDetailInputs
  private var merchantDetailOutputs: MerchantDetailOutputs?
  private let disposeBag = DisposeBag()
  private let isUserCoupon = BehaviorRelay<Bool>(value: false)

  // MARK: - Init

  init() {
    let subject = Subject()

    self.merchantDetailInputs = .init(
      loadData: subject.loadData.asObserver(),
      actionFromBottom: subject.actionFromBottom.asObserver()
    )

    let loadData = self.loadData(subject: subject)

    let onBottomButton = self.onBottomButton(subject: subject)

    let insertCoupon = self.insertCoupon(onBottomButton: onBottomButton, subject: subject)
    let deleteCoupon = self.deleteCoupon(onBottomButton: onBottomButton, subject: subject)

    self.isUserCoupon(
      loadData: loadData,
      insertCoupon: insertCoupon,
      deleteCoupon: deleteCoupon
    )
    .bind(to: self.isUserCoupon)
    .disposed(by: self.disposeBag)
    

    let title = self.title(subject: subject)
    let introduce = self.introduce(subject: subject)
    let buttonTitle = self.buttonTitle(subject: subject)
    let headerBackgroundColor = self.headerBackgroundColor(subject: subject)
    let headerImage = self.headerImage(subject: subject)
    let showCustomPopup = self.showCustomPopup(
      insertCoupon: insertCoupon,
      deleteCoupon: deleteCoupon
    )

    self.merchantDetailOutputs = .init(
      title: title,
      buttonTitle: buttonTitle,
      introduce: introduce,
      headerBackgroundColor: headerBackgroundColor,
      headerImage: headerImage,
      showCustomPopup: showCustomPopup
    )
  }

  // MARK: - Function

  private func title(subject: Subject) -> Observable<String> {
    return subject.loadData.map { $0.merchant?.name }
    .filterNil()
  }

  private func introduce(subject: Subject) -> Observable<String> {
    return subject.loadData.map { $0.merchant?.content }
    .filterNil()
  }

  private func headerBackgroundColor(subject: Subject) -> Observable<UIColor?> {
    return subject.loadData.map { $0.cellBackgroundColor }
  }

  private func headerImage(subject: Subject) -> Observable<UIImage> {
    return subject.loadData.map { $0.getCellImage() }
  }

  private func buttonTitle(subject: Subject) -> Observable<String> {
    return self.isUserCoupon.map { $0 ? Text.delete : Text.insert }
  }

  private func loadData(subject: Subject) -> Observable<Bool> {
    return subject.loadData
      .flatMapLatest { data -> Observable<Bool> in
      guard let merchant = data.merchant else {
        return .empty()
      }
      return RxCouponData.checkUserCoupon(
        userId: CouponSignleton.getUserId(),
        merchantId: merchant.merchantId
      )
      .asObservable()
    }
      .share()
  }

  private func onBottomButton(subject: Subject) -> Observable<Bool> {
    return subject.actionFromBottom
      .withLatestFrom(self.isUserCoupon)
      .share()
  }

  private func deleteCoupon(onBottomButton: Observable<Bool>, subject: Subject) -> Observable<Bool> {
    return onBottomButton
      .filter { $0 }
      .withLatestFrom(subject.loadData)
      .flatMapLatest { data -> Observable<Bool> in
        guard let merchant = data.merchant else {
          return .empty()
        }

        return RxCouponData.deleteUserCoupon(
          userId: CouponSignleton.getUserId(),
          merchantId: merchant.merchantId
        )
        .asObservable()
      }
      .share()
  }

  private func insertCoupon(onBottomButton: Observable<Bool>, subject: Subject) -> Observable<Bool> {
    return onBottomButton
      .filter { !$0 }
      .withLatestFrom(subject.loadData)
      .flatMapLatest { data -> Observable<Bool> in
        guard let merchant = data.merchant else {
          return .empty()
        }

        return RxCouponData.insertUserCoupon(
          userId: CouponSignleton.getUserId(),
          merchantId: merchant.merchantId
        )
        .asObservable()
      }
      .share()
  }

  private func isUserCoupon(
    loadData: Observable<Bool>,
    insertCoupon: Observable<Bool>,
    deleteCoupon: Observable<Bool>
  ) -> Observable<Bool> {

    let isUserCouponFromInsert = insertCoupon
      .map { $0 }

    let isUserCouponFromDelete = deleteCoupon
      .map { !$0 }

    return Observable.merge(
      loadData,
      isUserCouponFromInsert,
      isUserCouponFromDelete
    )
  }

  private func showCustomPopup(
    insertCoupon: Observable<Bool>,
    deleteCoupon: Observable<Bool>
  ) -> Observable<CustomPopup> {

    let popupFromInsertSuccess = insertCoupon
      .filter { $0 }
      .map { _ in
         CustomPopup(
          title: Text.insertCouponSuccessTitle.localized,
          message: Text.insertCouponSuccessContent.localized,
          callback: nil
         )
      }

    let popupFromInsertFail = insertCoupon
      .filter { !$0 }
      .map { _ in
         CustomPopup(
          title: Text.insertCouponFailTitle.localized,
          message: Text.insertCouponFailContent.localized,
          callback: nil
         )
      }

    let popupFromDeleteSuccess = deleteCoupon
      .filter { $0 }
      .map { _ in
         CustomPopup(
          title: Text.deleteCouponSuccessTitle.localized,
          message: Text.deleteCouponSuccessContent.localized,
          callback: nil
         )
      }

    let popupFromDeleteFail = deleteCoupon
      .filter { !$0 }
      .map { _ in
         CustomPopup(
          title: Text.deleteCouponFailTitle.localized,
          message: Text.deleteCouponFailContent.localized,
          callback: nil
         )
      }

    return Observable.merge(
      popupFromInsertSuccess,
      popupFromInsertFail,
      popupFromDeleteSuccess,
      popupFromDeleteFail
    )
  }
}
