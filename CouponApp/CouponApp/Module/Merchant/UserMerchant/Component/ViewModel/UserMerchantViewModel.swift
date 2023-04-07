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

  typealias DeleteCoupon = (userCouponList: UserCouponList, indexPath: IndexPath)

  private struct Subject {
    let merchantList = BehaviorSubject<MerchantList?>(value: nil)
    let loadData = PublishSubject<Void>()
    let deleteCoupon = PublishSubject<IndexPath>()
    let error = PublishSubject<Error>()
    let showCouponListViewController = PublishSubject<Merchant>()
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
      merchantList: subject.merchantList.asObserver(),
      loadData: subject.loadData.asObserver(),
      showCouponListViewController: subject.showCouponListViewController.asObserver() ,
      deleteCoupon: subject.deleteCoupon.asObserver()
    )

    let userCouponList = self.loadUserCouponList(subject: subject)

    self.outputs = UserMerchantOutputs(
      reloadSections: self.createSections(
        subject: subject,
        userCouponList: userCouponList
      ),
      updateCouponToDelete: self.updateCouponToDelete(
        subject: subject,
        userCouponList: userCouponList
      ),
      showCustomPopup: self.showCustomPopup(
        error: subject.error.asObservable()
      ),
      showCouponListViewController: self.showCouponListViewController(
        subject: subject,
        userCouponList: userCouponList
      )
    )
  }

  // MARK: - Method

  private func loadUserCouponList(subject: Subject) -> Observable<UserCouponList> {
    return subject.loadData
      .withLatestFrom(Me.instance.rx.userID)
      .flatMapLatest { id -> Observable<UserCouponList> in
        return CouponRepository.instance.rx.loadUserCouponData(userID: id)
          .asObservable()
          .suppressAndFeedError(into: subject.error)
          .compactMap { $0.data as? UserCouponList }
      }
      .share()
  }

  private func createSections(subject: Subject, userCouponList: Observable<UserCouponList>) -> Observable<[UserMerchantSection]> {
    return userCouponList.withLatestFrom(subject.merchantList.filterNil()) { userCouponlist, merchantList -> [Merchant] in
      return userCouponlist.list.compactMap { userCoupon -> Merchant? in
        return merchantList.index(merchantID: userCoupon.merchantID)
      }
    }
    .map { merchants -> [UserMerchantSection] in
      return [UserMerchantSection(items: merchants)]
    }
  }

  private func updateCouponToDelete(
    subject: Subject,
    userCouponList: Observable<UserCouponList>
  ) -> Observable<([UserMerchantSection], IndexPath)> {

    let deletedCoupon = self.deleteCoupon(subject: subject, userCouponList: userCouponList)
    let sections = self.createSections(
      subject: subject,
      userCouponList: deletedCoupon.map { userCouponList, indexPath in userCouponList }
    )

    return sections.withLatestFrom(deletedCoupon) { sections, deletedCoupon -> ([UserMerchantSection], IndexPath) in
      return (sections, deletedCoupon.indexPath)
    }
  }

  private func deleteCoupon(subject: Subject, userCouponList: Observable<UserCouponList>) -> Observable<DeleteCoupon> {
    let source = Observable.combineLatest(
      Me.instance.rx.userID,
      userCouponList
    )
    return subject.deleteCoupon
      .withLatestFrom(source) { indexPath, source in
        let userID = source.0
        let userCouponList = source.1
        return (userCouponList, indexPath, userID)
      }
      .flatMapLatest { (
        userCouponList: UserCouponList,
        indexPath: IndexPath,
        userID: Int
      ) -> Observable<DeleteCoupon> in
        guard let merchantID = userCouponList[indexPath.item]?.merchantID else { return .empty() }
         return CouponRepository.instance.rx.deleteUserCoupon(userID: userID, merchantID: merchantID)
        .asObservable()
        .suppressAndFeedError(into: subject.error)
        .compactMap { [weak userCouponList = userCouponList] _ in
          guard let userCouponList = userCouponList else { return nil }
          return (userCouponList, indexPath)
        }
        .do(onNext: { userCouponList, indexPath in
          var list = userCouponList
          list.remove(indexPath.row)
        })
      }
      .share()
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

  private func showCouponListViewController(
    subject: Subject,
    userCouponList: Observable<UserCouponList>
  ) -> Observable<CouponInfo> {
    return subject.showCouponListViewController.withLatestFrom(userCouponList) { merchant, userCouponList -> CouponInfo? in
      let userCoupon = userCouponList.list.first { userCoupon in
        return userCoupon.merchantID == merchant.merchantID
      }
      guard let userCoupon = userCoupon else { return nil }
      return .init(userCoupon: userCoupon, merchant: merchant)
    }
    .filterNil()
  }
}
