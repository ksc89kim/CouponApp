//
//  CouponListViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/28.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class CouponListViewModel: CouponListViewModelType {

  // MARK: - Define

  private struct Subject {
    let viewDidLoad = PublishSubject<Void>()
    let onAddCoupon = PublishSubject<Void>()
    let onUseCoupon = PublishSubject<Void>()
    let userCoupon = PublishSubject<UserCoupon?>()
    let merchantCoupon = PublishSubject<MerchantImpl?>()
  }

  private enum Text {
    static let maxCouponTitle = "maxCouponTitle"
    static let maxCouponContent = "maxCouponContent"
    static let requestFailCouponTitle = "requestFailCouponTitle"
    static let requestFailCouponContent = "requestFailCouponContent"
    static let lackCouponTitle = "lackCouponTitle"
    static let lackCouponContent = "lackCouponContent"
    static let successUseCouponTitle = "successUseCouponTitle"
    static let successUseCouponContent = "successUseCouponContent"
  }

  private struct CouponInfo {
    let userCoupon: UserCoupon
    let merchant: MerchantImpl
    let isNetworkSuccess: Bool

    init(userCoupon: UserCoupon, merchant: MerchantImpl) {
      self.userCoupon = userCoupon
      self.merchant = merchant
      self.isNetworkSuccess = false
    }

    init(couponInfo: CouponInfo, isNetworkSuccess: Bool) {
      self.userCoupon = couponInfo.userCoupon
      self.merchant = couponInfo.merchant
      self.isNetworkSuccess = isNetworkSuccess
    }

    func isAvailableAddCoupon() -> Bool {
      return self.userCoupon.couponCount < self.merchant.couponCount()
    }

    func isAvailableUseCoupon() -> Bool {
      return self.userCoupon.couponCount >= self.merchant.couponCount()
    }
  }

  private struct CouponParameter {
    let couponInfoWhenActionAfter: Observable<CouponInfo>
    let couponCount: Observable<Int>
    let isAvailableRequest: Observable<Bool>
  }

  private struct CustomPopupParameter {
    let isAvailableAddCoupon: Observable<Bool>
    let isAvailableUseCoupon: Observable<Bool>
    let responseAddCoupon: Observable<CouponInfo>
    let responseUseCoupon: Observable<CouponInfo>
  }

  // MARK: - Property

  var inputs: CouponListInputType { return self.couponListInputs }
  var outputs: CouponListOutputType? { return self.couponListOutputs }
  private let couponListInputs: CouponListInputs
  private var couponListOutputs: CouponListOutputs?

  // MARK: - Init

  init() {

    let subject = Subject()

    self.couponListInputs = .init(
      viewDidLoad: subject.viewDidLoad.asObserver(),
      onAddCoupon: subject.onAddCoupon.asObserver(),
      onUseCoupon: subject.onUseCoupon.asObserver(),
      userCoupon: subject.userCoupon.asObserver(),
      merchantCoupon: subject.merchantCoupon.asObserver()
    )

    let couponInfo = self.couponInfo(subject: subject)

    let couponInfoWhenOnAdd = self.couponInfoWhenActionAfter(
      onAction: subject.onAddCoupon.asObservable(),
      couponInfo: couponInfo
    )

    let isAvailableAddCoupon = couponInfoWhenOnAdd
      .map { $0.isAvailableAddCoupon() }
      .share()

    let responseAddCoupon = self.requestCouponNetwork(
      parameter: .init(
        couponInfoWhenActionAfter: couponInfoWhenOnAdd,
        couponCount: couponInfo.map { $0.userCoupon.couponCount + 1 },
        isAvailableRequest: isAvailableAddCoupon
      )
    )

    let couponInfoWhenOnUse = self.couponInfoWhenActionAfter(
      onAction: subject.onUseCoupon.asObservable(),
      couponInfo: couponInfo
    )

    let isAvailableUseCoupon = couponInfoWhenOnUse
      .map { $0.isAvailableUseCoupon() }
      .share()

    let responseUseCoupon = self.requestCouponNetwork(
      parameter: .init(
        couponInfoWhenActionAfter: couponInfoWhenOnUse,
        couponCount: .just(0),
        isAvailableRequest: isAvailableUseCoupon
      )
    )

    let selectedCouponIndex = self.selectedCouponIndex(
      responseAddCoupon: responseAddCoupon,
      subject: subject
    )

    let reload = self.reload(
      responseAddCoupon: responseAddCoupon,
      responseUseCoupon: responseUseCoupon
    )

    let showCustomPopup = self.customPopup(
      paramter: .init(
        isAvailableAddCoupon: isAvailableAddCoupon,
        isAvailableUseCoupon: isAvailableUseCoupon,
        responseAddCoupon: responseAddCoupon,
        responseUseCoupon: responseUseCoupon
      )
    )

    let navigationTitle = self.navigationTitle(subject: subject)

    self.couponListOutputs = .init(
      navigationTitle: navigationTitle,
      reload: reload,
      showCustomPopup: showCustomPopup,
      selectedCouponIndex: selectedCouponIndex
    )
  }

  // MARK: - Navigation Title

  private func navigationTitle(subject: Subject) -> Observable<String> {
    return subject.viewDidLoad
      .withLatestFrom(subject.merchantCoupon)
      .map { $0?.name }
      .filterNil()
  }

  // MARK: - CouponInfo Function

  private func couponInfo(subject: Subject) -> Observable<CouponInfo> {
    let userCoupon = subject.userCoupon
      .filterNil()

    let merchantCoupon = subject.merchantCoupon
      .filterNil()

    return Observable.combineLatest(
      userCoupon,
      merchantCoupon
    )
    .map { CouponInfo(userCoupon: $0.0, merchant: $0.1) }
    .share()
  }

  // MARK: - Request Network

  private func requestCouponNetwork(parameter: CouponParameter) -> Observable<CouponInfo> {
    let responseAddCoupon = self.reqeusetUpdateCoupon(
      parameter: parameter
    )

    return responseAddCoupon
      .withLatestFrom(parameter.couponInfoWhenActionAfter) { (isSuccess: Bool, couponInfo: CouponInfo) -> CouponInfo in
        return .init(couponInfo: couponInfo, isNetworkSuccess: isSuccess)
      }
      .share()
  }

  private func couponInfoWhenActionAfter(onAction: Observable<Void>, couponInfo: Observable<CouponInfo>) -> Observable<CouponInfo> {
    return onAction
      .withLatestFrom(couponInfo)
      .share()
  }

  private func reqeusetUpdateCoupon(parameter: CouponParameter) -> Observable<Bool> {
    return parameter.couponInfoWhenActionAfter
      .withLatestFrom(parameter.isAvailableRequest) { (couponInfo: $0, isAvailableRequest: $1) }
      .filter { $0.isAvailableRequest }
      .map { $0.couponInfo }
      .withLatestFrom(parameter.couponCount) { couponInfo, couponCount in
        return (couponInfo: couponInfo, couponCount: couponCount)
      }
      .flatMapLatest { couponInfo, couponCount -> Observable<Bool> in
        return RxCouponRepository.updateUesrCoupon(
          userId: CouponSignleton.getUserId(),
          merchantId: couponInfo.merchant.merchantId,
          couponCount: couponCount
        )
        .asObservable()
      }
      .share()
  }

  // MARK: - Select Coupon Index

  private func selectedCouponIndex(responseAddCoupon: Observable<CouponInfo>, subject: Subject) -> Observable<Int> {

    let selectIndexWhenViewDidLoad = subject.viewDidLoad
      .withLatestFrom(subject.userCoupon)
      .map { $0?.couponCount }
      .filterNil()

    let selectIndexWhenResponseAdd = responseAddCoupon
      .filter { $0.isNetworkSuccess }
      .do(onNext: { $0.userCoupon.addCouponCount() })
      .map { $0.userCoupon.couponCount - 1 }

    return Observable.merge(
      selectIndexWhenViewDidLoad,
      selectIndexWhenResponseAdd
    )
  }

  // MARK: - Reload

  private func reload(responseAddCoupon: Observable<CouponInfo>, responseUseCoupon: Observable<CouponInfo>) -> Observable<Void> {
    let reloadFromAddCoupon = self.reloadFromAddCoupon(responseAddCoupon: responseAddCoupon)
    let reloadFromUseCoupon = self.reloadFromUseCoupon(responseUseCoupon: responseUseCoupon)

    return Observable.merge(
      reloadFromAddCoupon,
      reloadFromUseCoupon
    )
  }

  private func reloadFromAddCoupon(responseAddCoupon: Observable<CouponInfo>) -> Observable<Void> {
    return responseAddCoupon
      .filter { $0.isNetworkSuccess }
      .map { _ in }
  }

  private func reloadFromUseCoupon(responseUseCoupon: Observable<CouponInfo>) -> Observable<Void> {
    return responseUseCoupon
      .filter { $0.isNetworkSuccess }
      .do(onNext: { couponInfo in
        couponInfo.userCoupon.clearCouponCount()
      })
      .map { _ in }
  }

  // MARK: - Custom Popup

  private func customPopup(
    paramter: CustomPopupParameter
  ) -> Observable<CustomPopup> {

    let customPopupWhenFullCoupon = self.customPopupWhenFullCoupon(paramter: paramter)
    let customPopupWhenLackCoupon = self.customPopupWhenLackCoupon(paramter: paramter)
    let customPopupWhenFailAddCoupon = self.customPopupWhenFailAddCoupon(paramter: paramter)
    let customPopupWhenUseCoupon = self.customPopupWhenUseCoupon(paramter: paramter)

    return Observable.merge(
      customPopupWhenFailAddCoupon,
      customPopupWhenFullCoupon,
      customPopupWhenLackCoupon,
      customPopupWhenUseCoupon
    )
  }

  private func customPopupWhenFailAddCoupon(paramter: CustomPopupParameter) -> Observable<CustomPopup> {
    return paramter.responseAddCoupon
      .filter { !$0.isNetworkSuccess }
      .map { _ in
        CustomPopup(
          title: Text.requestFailCouponTitle.localized,
          message: Text.requestFailCouponContent.localized,
          callback: nil
        )
      }
  }

  private func customPopupWhenFullCoupon(paramter: CustomPopupParameter) -> Observable<CustomPopup> {
    return paramter.isAvailableAddCoupon
      .filter { !$0 }
      .map { _ in
        CustomPopup(
          title: Text.maxCouponTitle.localized,
          message: Text.maxCouponContent.localized,
          callback: nil
        )
      }
  }

  private func customPopupWhenLackCoupon(paramter: CustomPopupParameter) -> Observable<CustomPopup> {
    return paramter.isAvailableUseCoupon
      .filter { !$0 }
      .map { _ in
        CustomPopup(
          title: Text.lackCouponTitle.localized,
          message: Text.lackCouponContent.localized,
          callback: nil
        )
      }
  }

  private func customPopupWhenUseCoupon(paramter: CustomPopupParameter) -> Observable<CustomPopup> {
    return paramter.responseUseCoupon
      .map { couponInfo -> CustomPopup in
        if couponInfo.isNetworkSuccess {
          return CustomPopup(
            title: Text.successUseCouponTitle.localized,
            message: Text.successUseCouponContent.localized,
            callback: nil
          )
        }
        return CustomPopup(
          title: Text.requestFailCouponTitle.localized,
          message: Text.requestFailCouponContent.localized,
          callback: nil
        )
      }
  }
}
