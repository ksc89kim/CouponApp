//
//  IntroViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/10/25.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional
import UIKit

final class IntroViewModel: IntroViewModelType {

  // MARK: - Define

  private struct Subject {
    let loadMertchant = PublishSubject<Void>()
    let error = PublishSubject<Error>()
  }

  // MARK: - Property

  var inputs: IntroInputType
  var outputs: IntroOutputType?

  // MARK: - Init

  init() {
    let subject = Subject()
    self.inputs = IntroInputs(
      loadMerchantData: subject.loadMertchant.asObserver()
    )

    let loadedMerchant = self.loadMerchant(subject: subject)

    let loadedPhoneNumber = self.loadPhoneNumber(merchant: loadedMerchant)

    let loadedUserData = self.loadUserData(phoneNumber: loadedPhoneNumber, errorObserver: subject.error.asObserver())

    let addLoginViewController = Observable.merge(
      subject.error
        .map { _ in },
      loadedPhoneNumber
        .filter { $0 == nil }
        .map { _ in }
    )

    let addMainViewController = loadedUserData
      .map { _ in }

    self.outputs = IntroOutputs(
      addLoginViewController: addLoginViewController,
      addMainViewController: addMainViewController
    )
  }

  // MARK: - Method

  private func loadMerchant(subject: Subject) -> Observable<RepositoryResponse> {
    return subject.loadMertchant
      .flatMapLatest { _ -> Observable<RepositoryResponse> in
        return CouponRepository.instance.rx.loadMerchantData()
          .asObservable()
          .do(onNext: { (response: RepositoryResponse) in
            MerchantController.instance.merchantList = response.data as? MerchantList
          })
          .suppressAndFeedError(into: subject.error)
    }
    .share()
  }

  private func loadPhoneNumber(merchant: Observable<RepositoryResponse>) -> Observable<String?> {
    return merchant
       .map { _ -> String? in
         return Phone().loadNumber()
     }
    .share()
  }

  private func loadUserData(phoneNumber: Observable<String?>, errorObserver: AnyObserver<Error>) -> Observable<RepositoryResponse> {
    return phoneNumber
      .filterNil()
      .flatMapLatest { phoneNumber -> Observable<RepositoryResponse> in
        return  CouponRepository.instance.rx.loadUserData(phoneNumber: phoneNumber)
          .asObservable()
          .do(onNext: { (response: RepositoryResponse) in
            guard let user = response.data as? User else { return }
            Me.instance.update(user: user)
          })
          .suppressAndFeedError(into: errorObserver)
      }
  }
}
