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
    let merchantDetail = BehaviorSubject<MerchantDetail?>(value: nil)
    let actionFromBottom = PublishSubject<Void>()
    let headerViewSize = PublishSubject<CGSize>()
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
      actionFromBottom: subject.actionFromBottom.asObserver(),
      headerViewSize: subject.headerViewSize.asObserver()
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
      deleteCoupon: deleteCoupon
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

  private func checkUser(subject: Subject) -> Observable<Bool> {
    return self.merchantDetail(subject: subject)
      .flatMapLatest { merchantDetail -> Observable<Bool> in
        return RxCouponRepository.checkUserCoupon(
          userId: CouponSignleton.getUserId(),
          merchantId: merchantDetail.merchant.merchantId
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
      .withLatestFrom(self.merchantDetail(subject: subject))
      .flatMapLatest { merchantDetail -> Observable<Bool> in
        return RxCouponRepository.deleteUserCoupon(
          userId: CouponSignleton.getUserId(),
          merchantId: merchantDetail.merchant.merchantId
        )
        .asObservable()
      }
      .share()
  }

  private func insertCoupon(onBottomButton: Observable<Bool>, subject: Subject) -> Observable<Bool> {
    return onBottomButton
      .filter { !$0 }
      .withLatestFrom(self.merchantDetail(subject: subject))
      .flatMapLatest { merchantDetail -> Observable<Bool> in
        return RxCouponRepository.insertUserCoupon(
          userId: CouponSignleton.getUserId(),
          merchantId: merchantDetail.merchant.merchantId
        )
        .asObservable()
      }
      .share()
  }

  private func isUserCoupon(
    checkUser: Observable<Bool>,
    insertCoupon: Observable<Bool>,
    deleteCoupon: Observable<Bool>
  ) -> Observable<Bool> {

    let isUserCouponFromInsert = insertCoupon
      .map { $0 }

    let isUserCouponFromDelete = deleteCoupon
      .map { !$0 }

    return Observable.merge(
      checkUser,
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
          completion: nil
         )
      }

    let popupFromInsertFail = insertCoupon
      .filter { !$0 }
      .map { _ in
         CustomPopup(
          title: Text.insertCouponFailTitle.localized,
          message: Text.insertCouponFailContent.localized,
          completion: nil
         )
      }

    let popupFromDeleteSuccess = deleteCoupon
      .filter { $0 }
      .map { _ in
         CustomPopup(
          title: Text.deleteCouponSuccessTitle.localized,
          message: Text.deleteCouponSuccessContent.localized,
          completion: nil
         )
      }

    let popupFromDeleteFail = deleteCoupon
      .filter { !$0 }
      .map { _ in
         CustomPopup(
          title: Text.deleteCouponFailTitle.localized,
          message: Text.deleteCouponFailContent.localized,
          completion: nil
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
