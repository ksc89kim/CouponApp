//
//  MerchantDetailViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/01/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class MerchantDetailViewModel: MerchantDetailViewModelType {

  // MARK: - Define

  private struct Subject {
    let merchantDetail = BehaviorSubject<MerchantDetail?>(value: nil)
    let actionFromBottom = PublishSubject<Void>()
    let error = PublishSubject<Error>()
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

  var inputs: MerchantDetailInputType
  var outputs: MerchantDetailOutputType?
  private let disposeBag = DisposeBag()
  private let isUserCoupon = BehaviorRelay<Bool>(value: false)

  // MARK: - Init

  init() {
    let subject = Subject()

    self.inputs = MerchantDetailInputs(
      merchantDetail: subject.merchantDetail.asObserver(),
      actionFromBottom: subject.actionFromBottom.asObserver()
    )

    let checkUser = self.checkUser(subject: subject)

    let onBottomButton = self.onBottomButton(subject: subject)

    let insertCoupon = self.insertCoupon(onBottomButton: onBottomButton, subject: subject)
    let deleteCoupon = self.deleteCoupon(onBottomButton: onBottomButton, subject: subject)

    self.isUserCoupon(
      checkUser: checkUser,
      insertCoupon: insertCoupon,
      deleteCoupon: deleteCoupon
    )
    .bind(to: self.isUserCoupon)
    .disposed(by: self.disposeBag)

    let showCustomPopup = self.showCustomPopup(
      insertCoupon: insertCoupon,
      deleteCoupon: deleteCoupon,
      error: subject.error
    )

    self.outputs = MerchantDetailOutputs(
      cellTopViewFrame: self.cellTopViewFrame(subject: subject),
      cellCornerRadius: self.cellCornerRadius(subject: subject),
      title: self.title(subject: subject),
      buttonTitle: self.buttonTitle(subject: subject),
      introduce: self.introduce(subject: subject),
      headerBackgroundColor:  self.headerBackgroundColor(subject: subject),
      headerImageURL: self.headerImageURL(subject: subject),
      showCustomPopup: showCustomPopup
    )
  }

  // MARK: - Method

  private func merchantDetail(subject: Subject) -> Observable<MerchantDetail> {
    return subject.merchantDetail.filterNil()
  }

  private func cellTopViewFrame(subject: Subject) -> Observable<CGRect> {
    return self.merchantDetail(subject: subject).map { $0.cellTopViewFrame }
  }

  private func cellCornerRadius(subject: Subject) -> Observable<CGFloat> {
    return self.merchantDetail(subject: subject).map { $0.cellCornerRadius }
  }

  private func title(subject: Subject) -> Observable<String> {
    return self.merchantDetail(subject: subject).map { $0.merchant.name }
  }

  private func introduce(subject: Subject) -> Observable<String> {
    return self.merchantDetail(subject: subject).map { $0.merchant.content }
  }

  private func headerBackgroundColor(subject: Subject) -> Observable<UIColor?> {
    return self.merchantDetail(subject: subject).map { UIColor.hexStringToUIColor(hex: $0.merchant.cardBackGround) }
  }

  private func headerImageURL(subject: Subject) -> Observable<URL?> {
    return self.merchantDetail(subject: subject).map { $0.merchant.logoImageUrl }
  }

  private func buttonTitle(subject: Subject) -> Observable<String> {
    return self.isUserCoupon.map { $0 ? Text.delete : Text.insert }
  }

  private func checkUser(subject: Subject) -> Observable<Void> {
    return self.merchantDetail(subject: subject)
      .withLatestFrom(Me.instance.rx.userID) { merchantDetail, id in
        return (merchantDetail, id)
      }
      .flatMapLatest { merchantDetail, id -> Observable<Void> in
        return CouponRepository.instance.rx.checkUserCoupon(
          userID: id,
          merchantID: merchantDetail.merchant.merchantID
        )
        .asObservable()
        .suppressAndFeedError(into: subject.error)
        .map { _ in }
      }
      .share()
  }

  private func onBottomButton(subject: Subject) -> Observable<Bool> {
    return subject.actionFromBottom
      .withLatestFrom(self.isUserCoupon)
      .share()
  }

  private func deleteCoupon(onBottomButton: Observable<Bool>, subject: Subject) -> Observable<Void> {
    return onBottomButton
      .filter { $0 }
      .withLatestFrom(self.merchantDetail(subject: subject))
      .withLatestFrom(Me.instance.rx.userID) { merchantDetail, id in
        return (merchantDetail, id)
      }
      .flatMapLatest { merchantDetail, id -> Observable<Void> in
        return CouponRepository.instance.rx.deleteUserCoupon(
          userID: id,
          merchantID: merchantDetail.merchant.merchantID
        )
        .asObservable()
        .suppressAndFeedError(into: subject.error)
        .map { _ in }
      }
      .share()
  }

  private func insertCoupon(onBottomButton: Observable<Bool>, subject: Subject) -> Observable<Void> {
    return onBottomButton
      .filter { !$0 }
      .withLatestFrom(self.merchantDetail(subject: subject))
      .withLatestFrom(Me.instance.rx.userID) { merchantDetail, id in
        return (merchantDetail, id)
      }
      .flatMapLatest { merchantDetail, id -> Observable<Void> in
        return CouponRepository.instance.rx.insertUserCoupon(
          userID: id,
          merchantID: merchantDetail.merchant.merchantID
        )
        .asObservable()
        .suppressAndFeedError(into: subject.error)
        .map { _ in }
      }
      .share()
  }

  private func isUserCoupon(
    checkUser: Observable<Void>,
    insertCoupon: Observable<Void>,
    deleteCoupon: Observable<Void>
  ) -> Observable<Bool> {

    let isUserCouponFromCheck = checkUser
      .map { true }

    let isUserCouponFromInsert = insertCoupon
      .map { true }

    let isUserCouponFromDelete = deleteCoupon
      .map { false }

    return Observable.merge(
      isUserCouponFromCheck,
      isUserCouponFromInsert,
      isUserCouponFromDelete
    )
  }

  private func showCustomPopup(
    insertCoupon: Observable<Void>,
    deleteCoupon: Observable<Void>,
    error: Observable<Error>
  ) -> Observable<CustomPopupConfigurable> {

    let popupFromInsertSuccess = insertCoupon
      .map { _ in
        var configuration: CustomPopupConfigurable = DIContainer.resolve(for: CustomPopupConfigurationKey.self)
        configuration.title = Text.insertCouponSuccessTitle.localized
        configuration.message = Text.insertCouponSuccessContent.localized
        return configuration
      }

    let popupFromInsertFail = error
      .filter { (error: Error) in
        guard let defaultError = error as? DefaultError,
              case .insertError = defaultError else { return false }
        return true
      }
      .map { _ in
        var configuration: CustomPopupConfigurable = DIContainer.resolve(for: CustomPopupConfigurationKey.self)
        configuration.title = Text.insertCouponFailTitle.localized
        configuration.message = Text.insertCouponFailContent.localized
        return configuration
      }

    let popupFromDeleteSuccess = deleteCoupon
      .map { _ in
        var configuration: CustomPopupConfigurable = DIContainer.resolve(for: CustomPopupConfigurationKey.self)
        configuration.title = Text.deleteCouponSuccessTitle.localized
        configuration.message = Text.deleteCouponSuccessContent.localized
        return configuration
      }

    let popupFromDeleteFail = error
      .filter { (error: Error) in
        guard let defaultError = error as? DefaultError,
              case .deleteError = defaultError else { return false }
        return true
      }
      .map { _ in
        var configuration: CustomPopupConfigurable = DIContainer.resolve(for: CustomPopupConfigurationKey.self)
        configuration.title = Text.deleteCouponFailTitle.localized
        configuration.message = Text.deleteCouponFailContent.localized
        return configuration
      }

    return Observable.merge(
      popupFromInsertSuccess,
      popupFromInsertFail,
      popupFromDeleteSuccess,
      popupFromDeleteFail
    )
  }
}
