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
    let loadCoupon = BehaviorSubject<CouponInfo?>(value: nil)
    let userCouponCount = BehaviorSubject<Int>(value: 0)
    let onAddCoupon = PublishSubject<Void>()
    let onUseCoupon = PublishSubject<Void>()
    let error = PublishSubject<Error>()
    let customPopup = PublishSubject<CustomPopup>()
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

  private struct CouponRequest {
    let couponInfoWhenActionAfter: Observable<CouponInfo>
    let couponCount: Observable<Int>
    let isAvailableRequest: Observable<Bool>
    let errorObserver: AnyObserver<Error>
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

    let couponInfo = self.couponInfo(subject: subject)
    let responseAddCoupon = self.addCoupon(couponInfo: couponInfo, subject: subject)
    let responseUseCoupon = self.useCoupon(couponInfo: couponInfo, subject: subject)

    let reloadSections = self.reloadSections(
      loadSections: .merge(couponInfo, responseAddCoupon, responseUseCoupon)
    )

    let showCustomPopup = self.customPopup(subject: subject)
    let navigationTitle = self.navigationTitle(subject: subject)

    self.outputs = CouponListOutputs(
      navigationTitle: navigationTitle,
      showCustomPopup: showCustomPopup,
      reloadSections: reloadSections
    )
  }

  // MARK: - CouponInfo

  private func couponInfo(subject: Subject) -> Observable<CouponInfo> {
    return subject.loadCoupon
      .filterNil()
      .do(onNext: { (couponInfo: CouponInfo) in
        subject.userCouponCount.onNext(couponInfo.userCoupon.couponCount)
      })
  }

  private func couponInfoWhenActionAfter(onAction: Observable<Void>, couponInfo: Observable<CouponInfo>) -> Observable<CouponInfo> {
    return onAction
      .withLatestFrom(couponInfo)
      .share()
  }

  // MARK: - ADD Methods

  private func addCoupon(couponInfo: Observable<CouponInfo>, subject: Subject) -> Observable<CouponInfo> {
    let couponInfoWhenOnAdd = self.couponInfoWhenActionAfter(
      onAction: subject.onAddCoupon.asObservable(),
      couponInfo: couponInfo
    )

    let isAvailableAddCoupon = self.isAvailableAddCoupon(
      couponInfoWhenOnAdd: couponInfoWhenOnAdd,
      customPopup: subject.customPopup.asObserver()
    )

    let responseAddCoupon = self.reqeusetUpdateCoupon(
      request: .init(
        couponInfoWhenActionAfter: couponInfoWhenOnAdd,
        couponCount: subject.userCouponCount.map { $0 + 1 },
        isAvailableRequest: isAvailableAddCoupon,
        errorObserver: subject.error.asObserver()
      )
    )
    .do(onNext: { (couponInfo: CouponInfo) in
      couponInfo.userCoupon.addCouponCount()
    })
    .do(onNext: { (couponInfo: CouponInfo) in
      subject.userCouponCount.onNext(couponInfo.userCoupon.couponCount)
    })

    return responseAddCoupon
  }

  private func isAvailableAddCoupon(
    couponInfoWhenOnAdd: Observable<CouponInfo>,
    customPopup: AnyObserver<CustomPopup>
  ) -> Observable<Bool> {
    return couponInfoWhenOnAdd
      .map { $0.isAvailableAddCoupon }
      .do(onNext: { (isAvailableAddCoupon: Bool) in
        guard !isAvailableAddCoupon else { return  }
        customPopup.onNext(
          .init(
            title: Text.maxCouponTitle.localized,
            message: Text.maxCouponContent.localized,
            completion: nil
          )
        )
      })
  }

  // MARK: - Use Methods

  private func useCoupon(couponInfo: Observable<CouponInfo>, subject: Subject) -> Observable<CouponInfo> {
    let couponInfoWhenOnUse = self.couponInfoWhenActionAfter(
      onAction: subject.onUseCoupon.asObservable(),
      couponInfo: couponInfo
    )

    let isAvailableUseCoupon = self.isAvailableUseCoupon(
      couponInfoWhenOnUse: couponInfoWhenOnUse,
      customPopup: subject.customPopup.asObserver()
    )

    let responseUseCoupon = self.reqeusetUpdateCoupon(
      request: .init(
        couponInfoWhenActionAfter: couponInfoWhenOnUse,
        couponCount: .just(0),
        isAvailableRequest: isAvailableUseCoupon,
        errorObserver: subject.error.asObserver()
      )
    )
    .do(onNext: { (couponInfo: CouponInfo) in
      couponInfo.userCoupon.clearCouponCount()
    })
    .do(onNext: { (couponInfo: CouponInfo) in
      subject.userCouponCount.onNext(couponInfo.userCoupon.couponCount)
    })
    .do(onNext: { (couponInfo: CouponInfo) in
      guard couponInfo.isAvailableUseCoupon else { return }
      subject.customPopup.onNext(
        .init(
          title: Text.successUseCouponTitle.localized,
          message: Text.successUseCouponContent.localized,
          completion: nil
        )
      )
    })

    return responseUseCoupon
  }

  private func isAvailableUseCoupon(
    couponInfoWhenOnUse: Observable<CouponInfo>,
    customPopup: AnyObserver<CustomPopup>
  ) -> Observable<Bool> {
    return couponInfoWhenOnUse
      .map { $0.isAvailableUseCoupon }
      .do(onNext: { (isAvailableUseCoupon: Bool) in
        guard !isAvailableUseCoupon else { return  }
        customPopup.onNext(
          .init(
            title: Text.lackCouponTitle.localized,
            message: Text.lackCouponContent.localized,
            completion: nil
          )
        )
      })
  }

  // MARK: - Reload

  private func reloadSections(loadSections: Observable<CouponInfo>) -> Observable<[CouponSection]> {
    return loadSections
      .map { (couponInfo: CouponInfo) -> [CouponSection] in
        let items: [CouponUIType] = (0 ..< couponInfo.merchant.couponCount()).map { (index: Int) -> CouponUIType in
          var item = couponInfo.merchant.index(index)
          item.isUseCoupon = (index < couponInfo.userCoupon.couponCount)
          item.isAnimation = (index == couponInfo.userCoupon.isSelectedIndex)
          return item
        }
        return [.init(items: items)]
      }
  }

  // MARK: - Request Network

  private func reqeusetUpdateCoupon(request: CouponRequest) -> Observable<CouponInfo> {
    return request.couponInfoWhenActionAfter
      .withLatestFrom(request.isAvailableRequest) { (couponInfo: $0, isAvailableRequest: $1) }
      .filter { $0.isAvailableRequest }
      .map { $0.couponInfo }
      .withLatestFrom(request.couponCount) { couponInfo, couponCount in
        return (couponInfo: couponInfo, couponCount: couponCount)
      }
      .withLatestFrom(Me.instance.rx.userID) { value, id in
        return (couponInfo: value.couponInfo, couponCount: value.couponCount, userID: id)
      }
      .flatMapLatest { couponInfo, couponCount, id -> Observable<RepositoryResponse> in
        return CouponRepository.instance.rx.updateUesrCoupon(
          userID: id,
          merchantID: couponInfo.merchant.merchantID,
          couponCount: couponCount
        )
        .asObservable()
        .suppressAndFeedError(into: request.errorObserver)
      }
      .withLatestFrom(request.couponInfoWhenActionAfter)
      .share()
  }

  // MARK: - Navigation Title

  private func navigationTitle(subject: Subject) -> Observable<String> {
    return subject.loadCoupon
      .compactMap { $0?.merchant.name }
  }

  // MARK: - Custom Popup

  private func customPopup(subject: Subject) -> Observable<CustomPopup> {
   let customPopupWhenUpdateFail =  subject.error
      .map { _ -> CustomPopup in
        return .init(
          title: Text.requestFailCouponTitle.localized,
          message: Text.requestFailCouponContent.localized,
          completion: nil
        )
      }

    return Observable.merge(
      customPopupWhenUpdateFail,
      subject.customPopup.asObservable()
    )
  }
}
