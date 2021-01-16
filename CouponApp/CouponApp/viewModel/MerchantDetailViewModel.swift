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

final class MerchantDetailViewModel: ViewModel {

  struct Inputs {
    let loadData = PublishSubject<MerchantDetail>()
    let actionFromBottom = PublishSubject<Void>()
  }

  struct Outputs {
    let title = PublishSubject<String>()
    let buttonTitle = PublishSubject<String>()
    let introduce = PublishSubject<String>()
    let headerBackgroundColor = PublishSubject<UIColor?>()
    let headerImage = PublishSubject<UIImage>()
    let showCustomPopup = PublishSubject<CustomPopup>()
  }

  struct BindInputs {
    let title: Observable<String>
    let buttonTitle: Observable<String>
    let introduce: Observable<String>
    let headerBackgroundColor: Observable<UIColor?>
    let headerImage: Observable<UIImage>
    let showCustomPopup: Observable<CustomPopup>
    let isUserCoupon: Observable<Bool>
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

  // MARK: - Properties

  let inputs = Inputs()
  let outputs = Outputs()
  private let disposeBag = DisposeBag()
  private let isUserCoupon = BehaviorRelay<Bool>(value: false)


  // MARK: - Init

  init() {
    let loadData = self.loadData()

    let onBottomButton = self.onBottomButton()

    let insertCoupon = self.insertCoupon(onBottomButton: onBottomButton)
    let deleteCoupon = self.deleteCoupon(onBottomButton: onBottomButton)

    let isUserCoupon = self.isUserCoupon(
      loadData: loadData,
      insertCoupon: insertCoupon,
      deleteCoupon: deleteCoupon
    )

    let title = self.title()
    let introduce = self.introduce()
    let buttonTitle = self.buttonTitle()
    let headerBackgroundColor = self.headerBackgroundColor()
    let headerImage = self.headerImage()
    let showCustomPopup = self.showCustomPopup(
      insertCoupon: insertCoupon,
      deleteCoupon: deleteCoupon
    )

    self.bind(
      inputs: .init(
        title: title,
        buttonTitle: buttonTitle,
        introduce: introduce,
        headerBackgroundColor: headerBackgroundColor,
        headerImage: headerImage,
        showCustomPopup: showCustomPopup,
        isUserCoupon: isUserCoupon
      )
    )
  }

  func bind(inputs: BindInputs) {
    inputs.title
      .bind(to: self.outputs.title)
      .disposed(by: self.disposeBag)

    inputs.introduce
      .bind(to: self.outputs.introduce)
      .disposed(by: self.disposeBag)

    inputs.buttonTitle
      .bind(to: self.outputs.buttonTitle)
      .disposed(by: self.disposeBag)

    inputs.headerBackgroundColor
      .bind(to: self.outputs.headerBackgroundColor)
      .disposed(by: self.disposeBag)

    inputs.headerImage
      .bind(to: self.outputs.headerImage)
      .disposed(by: self.disposeBag)

    inputs.showCustomPopup
      .bind(to: self.outputs.showCustomPopup)
      .disposed(by: self.disposeBag)

    inputs.isUserCoupon
      .bind(to: self.isUserCoupon)
      .disposed(by: self.disposeBag)
  }

  private func title() -> Observable<String> {
    return self.inputs.loadData.map { $0.merchant?.name }
    .filterNil()
  }

  private func introduce() -> Observable<String> {
    return self.inputs.loadData.map { $0.merchant?.content }
    .filterNil()
  }

  private func headerBackgroundColor() -> Observable<UIColor?> {
    return self.inputs.loadData.map { $0.cellBackgroundColor }
  }

  private func headerImage() -> Observable<UIImage> {
    return self.inputs.loadData.map { $0.getCellImage() }
  }

  private func buttonTitle() -> Observable<String> {
    return self.isUserCoupon.map { $0 ? Text.delete : Text.insert }
  }

  private func loadData() -> Observable<Bool> {
    return self.inputs.loadData
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

  private func onBottomButton() -> Observable<Bool> {
    return self.inputs.actionFromBottom
      .withLatestFrom(self.isUserCoupon)
      .share()
  }

  private func deleteCoupon(onBottomButton: Observable<Bool>) -> Observable<Bool> {
    return onBottomButton
      .filter { $0 }
      .withLatestFrom(self.inputs.loadData)
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

  private func insertCoupon(onBottomButton: Observable<Bool>) -> Observable<Bool> {
    return onBottomButton
      .filter { !$0 }
      .withLatestFrom(self.inputs.loadData)
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
