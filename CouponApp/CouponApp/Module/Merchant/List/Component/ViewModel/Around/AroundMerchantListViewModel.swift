//
//  AroundMerchantListViewModel.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/06.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import CoreLocation

final class AroundMerchantListViewModel: MerchantListViewModel {

  // MARK: - Define

  struct Subject {
    let merchantList = BehaviorSubject<MerchantList?>(value: nil)
    let selectItem = PublishSubject<MerchantSelect>()
    let didUpdateLocation = PublishSubject<CLLocationManager>()
  }

  private enum Constant {
    static let maxDistance: Double = 1000
  }

  // MARK: - Init

  override init() {
    super.init()

    let subject = Subject()

    self.inputs = AroundMerchantListInputs(
      selecItem: subject.selectItem.asObserver(),
      merchantList: subject.merchantList.asObserver(),
      didUpdateLocation: subject.didUpdateLocation.asObserver()
    )

    self.outputs = AroundMerchantListOutputs(
      reloadSections: self.reloadSections(subject: subject),
      presentDetail: self.presentDetail(selectItem: subject.selectItem.asObservable())
    )
  }

  // MARK: - Method

  private func reloadSections(subject: Subject) -> Observable<[MerchantListSection]> {
    return subject.didUpdateLocation
      .withLatestFrom(subject.merchantList.filterNil()) { (
        manager: CLLocationManager,
        list: MerchantList
      ) -> [MerchantListSection]? in
        guard let coor = manager.location?.coordinate else { return nil }
        let location = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
        let merchants = list.list.filter { (merchant: Merchant) -> Bool in
          let merchantLocation = CLLocation(latitude: merchant.latitude, longitude: merchant.longitude)
          let diffDistance = location.distance(from: merchantLocation)
          return diffDistance < Constant.maxDistance
        }
        guard merchants.isNotEmpty else { return nil }
        return [.init(items: merchants)]
      }
      .filterNil()
  }
}
