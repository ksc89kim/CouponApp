//
//  MerchantViewModel.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/03.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class MerchantListViewModel: MerchantListViewModelType {

  // MARK: - Define

  struct Subject {
    let merchantList = BehaviorSubject<MerchantList?>(value: nil)
    let selectItem = PublishSubject<MerchantSelect>()
  }

  // MARK: - Property

  var inputs: MerchantListInputType
  var outputs: MerchantListOutputType?

  // MARK: - Init

  init() {
    let subject = Subject()

    self.inputs = MerchantListInputs(
      selecItem: subject.selectItem.asObserver(),
      merchantList: subject.merchantList.asObserver()
    )

    self.outputs = MerchantListOutputs(
      reloadSections: self.reloadSections(merchantList: subject.merchantList.asObservable()),
      presentDetail: self.presentDetail(selectItem: subject.selectItem.asObservable())
    )
  }

  // MARK: - Methods

  func reloadSections(merchantList: Observable<MerchantList?>) -> Observable<[MerchantListSection]> {
    return merchantList.compactMap { (merchatList: MerchantList?) -> [MerchantListSection]? in
      guard let merchatList = merchatList else { return nil }
      return [.init(items: merchatList.list)]
    }
  }

  func presentDetail(selectItem: Observable<MerchantSelect>) -> Observable<MerchantDetail> {
    return selectItem.map { (select: MerchantSelect) -> MerchantDetail in
      let positionY = select.cellFrame.origin.y - select.contentOffset.y + MerchantTableViewCell.Metric.headerTopHeight
      var frame = select.cellTopViewFrame
      frame.origin.y = positionY
      return .init(
        cellCornerRadius: select.cornerRadius,
        cellTopViewFrame: frame,
        merchant: select.item
      )
    }
  }
}
