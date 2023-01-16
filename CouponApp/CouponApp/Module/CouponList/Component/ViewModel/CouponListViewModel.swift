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
    let loadCoupon = PublishSubject<CouponInfo>()
    let onAddCoupon = PublishSubject<Void>()
    let onUseCoupon = PublishSubject<Void>()
    let error = PublishSubject<Error>()
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

  private struct CouponParameter {
    let couponInfoWhenActionAfter: Observable<CouponInfo>
    let couponCount: Observable<Int>
    let isAvailableRequest: Observable<Bool>
    let errorObserver: AnyObserver<Error>
  }

  private struct CustomPopupParameter {
    let isAvailableAddCoupon: Observable<Bool>
    let isAvailableUseCoupon: Observable<Bool>
    let responseAddCoupon: Observable<CouponInfo>
    let responseUseCoupon: Observable<CouponInfo>
    let error: Observable<Error>
  }

  // MARK: - Property

  var inputs: CouponListInputType
  var outputs: CouponListOutputType?


  // MARK: - Init

  init() {

    let subject = Subject()

    self.inputs = CouponListInputs(
      loadCoupon: subject.loadCoupon.asObserver(),
      onAddCoupon: subject.onAddCoupon.asObserver(),
      onUseCoupon: subject.onUseCoupon.asObserver()
    )

    let couponInfo = subject.loadCoupon.asObservable()

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
        isAvailableRequest: isAvailableAddCoupon,
        errorObserver: subject.error.asObserver()
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
        isAvailableRequest: isAvailableUseCoupon,
        errorObserver: subject.error.asObserver()
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
      parameter: .init(
        isAvailableAddCoupon: isAvailableAddCoupon,
        isAvailableUseCoupon: isAvailableUseCoupon,
        responseAddCoupon: responseAddCoupon,
        responseUseCoupon: responseUseCoupon,
        error: subject.error
      )
    )

    let navigationTitle = self.navigationTitle(subject: subject)

    self.outputs = CouponListOutputs(
      navigationTitle: navigationTitle,
      reload: reload,
      showCustomPopup: showCustomPopup,
      selectedCouponIndex: selectedCouponIndex
    )
  }

  // MARK: - Navigation Title

  private func navigationTitle(subject: Subject) -> Observable<String> {
    return subject.loadCoupon
      .map { $0.merchant.name }
  }

  // MARK: - Request Network

  private func requestCouponNetwork(parameter: CouponParameter) -> Observable<CouponInfo> {
    let responseCoupon = self.reqeusetUpdateCoupon(
      parameter: parameter
    )

    return responseCoupon
      .withLatestFrom(parameter.couponInfoWhenActionAfter)
      .share()
  }

  private func couponInfoWhenActionAfter(onAction: Observable<Void>, couponInfo: Observable<CouponInfo>) -> Observable<CouponInfo> {
    return onAction
      .withLatestFrom(couponInfo)
      .share()
  }

  private func reqeusetUpdateCoupon(parameter: CouponParameter) -> Observable<RepositoryResponse> {
    return parameter.couponInfoWhenActionAfter
      .withLatestFrom(parameter.isAvailableRequest) { (couponInfo: $0, isAvailableRequest: $1) }
      .filter { $0.isAvailableRequest }
      .map { $0.couponInfo }
      .withLatestFrom(parameter.couponCount) { couponInfo, couponCount in
        return (couponInfo: couponInfo, couponCount: couponCount)
      }
      .withLatestFrom(Me.instance.rx.userID) { value, id in
        return (couponInfo: value.couponInfo, couponCount: value.couponCount, userID: id)
      }
      .flatMapLatest { couponInfo, couponCount, id -> Observable<RepositoryResponse> in
        return CouponRepository.instance.rx.updateUesrCoupon(
          userId: id,
          merchantId: couponInfo.merchant.merchantId,
          couponCount: couponCount
        )
        .asObservable()
        .suppressAndFeedError(into: parameter.errorObserver)
      }
      .share()
  }

  // MARK: - Select Coupon Index

  private func selectedCouponIndex(responseAddCoupon: Observable<CouponInfo>, subject: Subject) -> Observable<Int> {

    let selectIndexWhenViewDidLoad = subject.loadCoupon
      .map { $0.userCoupon.couponCount }

    let selectIndexWhenResponseAdd = responseAddCoupon
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
      .map { _ in }
  }

  private func reloadFromUseCoupon(responseUseCoupon: Observable<CouponInfo>) -> Observable<Void> {
    return responseUseCoupon
      .do(onNext: { couponInfo in
        couponInfo.userCoupon.clearCouponCount()
      })
      .map { _ in }
  }

  // MARK: - Custom Popup

  private func customPopup(
    parameter: CustomPopupParameter
  ) -> Observable<CustomPopup> {

    let customPopupWhenFullCoupon = self.customPopupWhenFullCoupon(parameter: parameter)
    let customPopupWhenLackCoupon = self.customPopupWhenLackCoupon(parameter: parameter)
    let customPopupWhenFailAddCoupon = self.customPopupWhenFailCoupon(parameter: parameter)
    let customPopupWhenUseCoupon = self.customPopupWhenUseCoupon(parameter: parameter)

    return Observable.merge(
      customPopupWhenFailAddCoupon,
      customPopupWhenFullCoupon,
      customPopupWhenLackCoupon,
      customPopupWhenUseCoupon
    )
  }

  private func customPopupWhenFailCoupon(parameter: CustomPopupParameter) -> Observable<CustomPopup> {
    return parameter.error
      .map { _ in
        CustomPopup(
          title: Text.requestFailCouponTitle.localized,
          message: Text.requestFailCouponContent.localized,
          completion: nil
        )
      }
  }

  private func customPopupWhenFullCoupon(parameter: CustomPopupParameter) -> Observable<CustomPopup> {
    return parameter.isAvailableAddCoupon
      .filter { !$0 }
      .map { _ in
        CustomPopup(
          title: Text.maxCouponTitle.localized,
          message: Text.maxCouponContent.localized,
          completion: nil
        )
      }
  }

  private func customPopupWhenLackCoupon(parameter: CustomPopupParameter) -> Observable<CustomPopup> {
    return parameter.isAvailableUseCoupon
      .filter { !$0 }
      .map { _ in
        CustomPopup(
          title: Text.lackCouponTitle.localized,
          message: Text.lackCouponContent.localized,
          completion: nil
        )
      }
  }

  private func customPopupWhenUseCoupon(parameter: CustomPopupParameter) -> Observable<CustomPopup> {
    return parameter.responseUseCoupon
      .map { couponInfo -> CustomPopup in
        return CustomPopup(
          title: Text.successUseCouponTitle.localized,
          message: Text.successUseCouponContent.localized,
          completion: nil
        )
      }
  }
}
