//
//  CustomPopupViewModel.swift
//  CouponApp
//
//  Created by sc.kim on 2020/12/06.
//  Copyright © 2020 kim sunchul. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class CustomPopupViewModel: CustomPopupViewModelType {

  // MARK: - Define

  private struct Subject {
    let configure = BehaviorSubject<CustomPopupConfigurable?>(value: nil)
    let onOk = PublishSubject<Void>()
    let showPopup = PublishSubject<Void>()
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
      showPopup: subject.showPopup.asObserver()
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

  private func close(subject: Subject, configure: Observable<CustomPopupConfigurable>) -> Observable<CustomPopupConfigurable> {
    return subject.onOk
      .withLatestFrom(configure)
  }

  private func delayShowAnimation(subject: Subject) -> Observable<Void> {
    return subject.showPopup
      .delay(.milliseconds(100), scheduler: MainScheduler.instance)
  }

  private func configre(subject: Subject) -> Observable<CustomPopupConfigurable> {
    return subject.showPopup
      .withLatestFrom(subject.configure)
      .filterNil()
      .share()
  }

  private func title(configure: Observable<CustomPopupConfigurable>) -> Observable<String> {
    return configure.map { $0.title }
  }

  private func content(configure: Observable<CustomPopupConfigurable>) -> Observable<String> {
    return configure.map { $0.message }
  }

  private func popupViewAlpha(configure: Observable<CustomPopupConfigurable>) -> Observable<CGFloat> {
    return configure.map { _ in 0 }
  }
}
