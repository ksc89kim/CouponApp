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

  private struct Response {
    let isSuccess: Bool
    let phoneNumber: String
  }

  // MARK: - Property

  var inputs: LoginInputType { return self.loginInputs }
  var outputs: LoginOutputType? { return self.loginOutputs }
  private let loginInputs: LoginInputs
  private var loginOutputs: LoginOutputs?

  // MARK: - Init

  init() {

    let subject = Subject()

    self.loginInputs = .init(
      onSingup: subject.onSingup.asObserver(),
      onLogin: subject.onLogin.asObserver(),
      userPhoneNumber: subject.userPhoneNumber.asObserver(),
      userPassword: subject.userPassword.asObserver()
    )

    let textInput = self.getTextInput(subject: subject)

    let afterLogin = self.login(textInput: textInput)

    let showCustomPopup = self.showCustomPopup(
      textInput: textInput,
      afterLogin: afterLogin
    )

    let showMainViewController = self.showMainViewController(afterLogin: afterLogin)

    let showSignupViewController = self.showSignupViewController(onSignup: subject.onSingup)

    let savePhoneNumber = self.savePhoneNumber(afterLogin: afterLogin)

    self.loginOutputs = .init(
      showCustomPopup: showCustomPopup,
      showMainViewController: showMainViewController,
      savePhoneNumber: savePhoneNumber,
      showSignupViewController: showSignupViewController
    )
  }

  // MARK: - Function

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

  private func showCustomPopup(textInput: TextInput, afterLogin: Observable<Response>) -> Observable<CustomPopup> {

    return Observable.merge(
      self.inputFaileMessage(textInput: textInput),
      self.networkFailMessage(afterLogin: afterLogin)
    )
    .map { message in
      .init(
        title: Text.signupFailTitle.localized,
        message: message,
        callback: nil
      )
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

  private func networkFailMessage(afterLogin: Observable<Response>) -> Observable<String> {
    let loginFail = afterLogin
      .filter { !$0.isSuccess }
      .map { _ in }

    return loginFail
    .map { _ in Text.phoneNumberOrPasswordFail.localized }
  }

  private func showMainViewController(afterLogin: Observable<Response>) -> Observable<Void> {
    return afterLogin
      .filter { $0.isSuccess }
      .map { _ in }
  }

  private func showSignupViewController(onSignup: Observable<Void>) -> Observable<Void> {
    return onSignup
      .map { _ in }
  }

  private func savePhoneNumber(afterLogin: Observable<Response>) -> Observable<String> {
    return afterLogin
      .filter { $0.isSuccess }
      .map { $0.phoneNumber }
  }

  private func login(textInput: TextInput) -> Observable<Response> {

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
    .flatMapLatest { phoneNumber, password -> Observable<Bool> in
      return RxCouponRepository.checkPassword(phoneNumber: phoneNumber, password: password)
        .asObservable()
    }
    .withLatestFrom(phoneNumber) { .init(isSuccess: $0, phoneNumber: $1) }
    .share()
  }

}

