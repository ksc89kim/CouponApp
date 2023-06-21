//
//  LoginViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/01.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class LoginViewModel: LoginViewModelType {

  // MARK: - Define

  private struct Subject {
    let onSingup = PublishSubject<Void>()
    let onLogin = PublishSubject<Void>()
    let userPhoneNumber = PublishSubject<String?>()
    let userPassword = PublishSubject<String?>()
    let error = PublishSubject<Error>()
  }

  private enum Text {
    static let signupFailTitle = "loginFailTitle"
    static let phoneNumberOrPasswordFail = "phoneNumberOrPasswordFail"
    static let phoneNumberNeedInput = "phoneNumberNeedInput"
    static let passwordNeedInput = "passwordNeedInput"
  }

  private struct TextInput {
    let phoneNumber: Observable<String?>
    let password: Observable<String?>
  }

  // MARK: - Property

  var inputs: LoginInputType
  var outputs: LoginOutputType?

  // MARK: - Init

  init() {

    let subject = Subject()

    self.inputs = LoginInputs(
      onSingup: subject.onSingup.asObserver(),
      onLogin: subject.onLogin.asObserver(),
      userPhoneNumber: subject.userPhoneNumber.asObserver(),
      userPassword: subject.userPassword.asObserver()
    )

    let textInput = self.getTextInput(subject: subject)

    let afterLogin = self.login(textInput: textInput, errorObserver: subject.error.asObserver())

    let showCustomPopup = self.showCustomPopup(
      textInput: textInput,
      error: subject.error
    )

    let showMainViewController = self.showMainViewController(afterLogin: afterLogin)

    let showSignupViewController = self.showSignupViewController(onSignup: subject.onSingup)

    self.outputs = LoginOutputs(
      showCustomPopup: showCustomPopup,
      showMainViewController: showMainViewController,
      showSignupViewController: showSignupViewController
    )
  }

  // MARK: - Method

  private func getTextInput(subject: Subject) -> TextInput {
    let onLogin = subject.onLogin.share()
    let phoneNumber = self.getStringWhenOnLogin(onLogin: onLogin, text: subject.userPhoneNumber)
    let password = self.getStringWhenOnLogin(onLogin: onLogin, text: subject.userPassword)

    return .init(
      phoneNumber: phoneNumber,
      password: password
    )
  }

  private func getStringWhenOnLogin(onLogin: Observable<Void>, text: Observable<String?>) -> Observable<String?> {
    return onLogin
      .withLatestFrom(text)
      .share()
  }

  private func showCustomPopup(textInput: TextInput, error: Observable<Error>) -> Observable<CustomPopupConfigurable> {
    return Observable.merge(
      self.inputFaileMessage(textInput: textInput),
      self.networkFailMessage(error: error)
    )
    .map { message in
      var configuration: CustomPopupConfigurable = DIContainer.resolve(for: CustomPopupConfigurationKey.self)
      configuration.title = Text.signupFailTitle.localized
      configuration.message = message
      return configuration
    }
  }

  private func inputFaileMessage(textInput: TextInput) -> Observable<String> {
    return Observable.zip(
      textInput.phoneNumber,
      textInput.password
    )
    .flatMapLatest{ phoneNumber, password -> Observable<String> in

      guard let phoneNumber = phoneNumber, phoneNumber.isNotEmpty else {
        return .just(Text.phoneNumberNeedInput.localized)
      }

      guard let password = password, password.isNotEmpty else {
        return .just(Text.passwordNeedInput.localized)
      }

      return .empty()
    }
  }

  private func networkFailMessage(error: Observable<Error>) -> Observable<String> {
    return error
      .map { _ in Text.phoneNumberOrPasswordFail.localized }
  }

  private func showMainViewController(afterLogin: Observable<String>) -> Observable<Void> {
    return afterLogin
      .map { _ in }
  }

  private func showSignupViewController(onSignup: Observable<Void>) -> Observable<Void> {
    return onSignup
      .map { _ in }
  }

  private func login(textInput: TextInput, errorObserver: AnyObserver<Error>) -> Observable<String> {
    let phoneNumber = textInput.phoneNumber
      .filterNil()
      .filter { $0.isNotEmpty }

    let password = textInput.password
      .filterNil()
      .filter { $0.isNotEmpty }

    return Observable.zip(
      phoneNumber,
      password
    )
    .flatMapLatest { phoneNumber, password -> Observable<String> in
      return CouponRepository.instance.rx.checkPassword(phoneNumber: phoneNumber, password: password)
        .asObservable()
        .suppressAndFeedError(into: errorObserver)
        .map { _ in phoneNumber }
    }
    .do(onNext: { (phoneNumber: String) in
      let phone: PhoneType = DIContainer.resolve(for: PhoneKey.self)
      phone.saveNumber(phoneNumber)
    })
    .share()
  }

}

