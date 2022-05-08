//
//  CustomPopupViewModel.swift
//  CouponApp
//
//  Created by sc.kim on 2020/12/06.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class CustomPopupViewModel: CustomPopupViewModelType {

  // MARK: - Define

  private struct Subject {
    let configure = BehaviorSubject<CustomPopup?>(value: nil)
    let onOk = PublishSubject<Void>()
    let viewDidLoad = PublishSubject<Void>()
  }

  // MARK: - Property

  var inputs: CustomPopupInputType
  var outputs: CustomPopupOutputType?


  // MARK: - Init

  init() {
    let subject = Subject()

    self.inputs = CustomPopupInputs(
      configure: subject.configure.asObserver(),
      onOk: subject.onOk.asObserver(),
      viewDidLoad: subject.viewDidLoad.asObserver()
    )

    let showAnimation = self.delayShowAnimation(subject: subject)
    let configure = self.configre(subject: subject)
    let close = self.close(subject: subject, configure: configure)

    let title = self.title(configure: configure)
    let content = self.content(configure: configure)
    let popupViewAlpha = self.popupViewAlpha(configure: configure)


    self.outputs = CustomPopupOutputs(
      content: content,
      showAnimation: showAnimation,
      close: close,
      title: title,
      popupViewAlpha: popupViewAlpha
    )
  }

  // MARK: - Method

  private func close(subject: Subject, configure: Observable<CustomPopup>) -> Observable<CustomPopup> {
    return subject.onOk
      .withLatestFrom(configure)
  }

  private func delayShowAnimation(subject: Subject) -> Observable<Void> {
    return subject.viewDidLoad
      .delay(.milliseconds(100), scheduler: MainScheduler.instance)
  }

  private func configre(subject: Subject) -> Observable<CustomPopup> {
    return subject.viewDidLoad
      .withLatestFrom(subject.configure)
      .filterNil()
      .share()
  }

  private func title(configure: Observable<CustomPopup>) -> Observable<String> {
    return configure.map { $0.title }
  }

  private func content(configure: Observable<CustomPopup>) -> Observable<String> {
    return configure.map { $0.message }
  }

  private func popupViewAlpha(configure: Observable<CustomPopup>) -> Observable<CGFloat> {
    return configure.map { _ in 0 }
  }
}
