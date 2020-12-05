//
//  SignupViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/01.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class SignupViewModel: ViewModel {

  struct Inputs {
    let onSingup = PublishSubject<Void>()
    let userName = PublishSubject<String?>()
    let userPhoneNumber = PublishSubject<String?>()
    let userPassword = PublishSubject<String?>()
  }

  struct Outputs {
    let showCustomPopup = PublishSubject<CustomPopup>()
    let showMainViewController = PublishSubject<Void>()
    let savePhoneNumber = PublishSubject<String>()
  }

  struct BindInputs {
    let showCustomPopup: Observable<CustomPopup>
    let showMainViewController: Observable<Void>
    let savePhoneNumber: Observable<String>
  }

  private enum Text {
    static let signupFailTitle = "signupFailTitle"
    static let signupFailContent = "signupFailContent"
    static let nameNeedInput = "nameNeedInput"
    static let phoneNumberNeedInput = "phoneNumberNeedInput"
    static let passwordNeedInput = "passwordNeedInput"
  }

  private struct TextInput {
    let name: Observable<String?>
    let phoneNumber: Observable<String?>
    let password: Observable<String?>
  }

  private struct Response {
    let isSuccess: Bool
    let phoneNumber: String
  }

  // MARK: - Property

  let inputs = Inputs()
  let outputs = Outputs()
  private let disposeBag = DisposeBag()

  // MARK: - Init

  init() {
    let onSignup = self.inputs.onSingup
      .share()

    let textInput = self.getTextInput(onSignup: onSignup)

    let afterSignup = self.signup(textInput: textInput)

    let loadedUser = self.loadUser(afterSignup: afterSignup)

    let showCustomPopup = self.showCustomPopup(
      textInput: textInput,
      afterSignup: afterSignup,
      loadedUser: loadedUser
    )

    let showMainViewController = self.showMainViewController(loadedUser: loadedUser)

    let savePhoneNumber = self.savePhoneNumber(loadedUser: loadedUser)

    self.bind(
      inputs: .init(
        showCustomPopup: showCustomPopup,
        showMainViewController: showMainViewController,
        savePhoneNumber: savePhoneNumber
      )
    )
  }

  // MARK: - Bind

  func bind(inputs: BindInputs) {
    inputs.showCustomPopup
      .bind(to: self.outputs.showCustomPopup)
      .disposed(by: self.disposeBag)

    inputs.showMainViewController
      .bind(to: self.outputs.showMainViewController)
      .disposed(by: self.disposeBag)

    inputs.savePhoneNumber
      .bind(to: self.outputs.savePhoneNumber)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Functions

  private func getTextInput(
    onSignup: Observable<Void>
  ) -> TextInput {
    let userName = self.getStringWhenOnSignup(onSignup: onSignup, text: self.inputs.userName)
    let phoneNumber = self.getStringWhenOnSignup(onSignup: onSignup, text: self.inputs.userPhoneNumber)
    let password = self.getStringWhenOnSignup(onSignup: onSignup, text: self.inputs.userPassword)

    return .init(
      name: userName,
      phoneNumber: phoneNumber,
      password: password
    )
  }

  private func getStringWhenOnSignup(
    onSignup: Observable<Void>,
    text: Observable<String?>
  ) -> Observable<String?> {
    return onSignup
      .withLatestFrom(text)
      .share()
  }

  private func showCustomPopup(
    textInput: TextInput,
    afterSignup: Observable<Response>,
    loadedUser: Observable<Response>
  ) -> Observable<CustomPopup> {

    return Observable.merge(
      self.inputFaileMessage(textInput: textInput),
      self.networkFailMessage(
        afterSignup: afterSignup,
        loadedUser: loadedUser
      )
    )
    .map { message in
      .init(
        title: Text.signupFailTitle.localized,
        message: message,
        callback: nil
      )
    }
  }

  private func inputFaileMessage(
    textInput: TextInput
  ) -> Observable<String> {
    return Observable.zip(
      textInput.name,
      textInput.phoneNumber,
      textInput.password
    )
    .flatMapLatest{ name, phoneNumber, password -> Observable<String> in
      guard let name = name, name.isNotEmpty else {
        return .just(Text.nameNeedInput.localized)
      }

      guard let phoneNumber = phoneNumber, phoneNumber.isNotEmpty else {
        return .just(Text.phoneNumberNeedInput.localized)
      }

      guard let password = password, password.isNotEmpty else {
        return .just(Text.passwordNeedInput.localized)
      }

      return .empty()
    }
  }

  private func networkFailMessage(
    afterSignup: Observable<Response>,
    loadedUser: Observable<Response>
  ) -> Observable<String> {
    let signupFail = afterSignup
      .filter { !$0.isSuccess }
      .map { _ in }

    let loadedUserFail = loadedUser
      .filter { !$0.isSuccess }
      .map { _ in }

    return Observable.merge(
      signupFail,
      loadedUserFail
    )
    .map { _ in Text.signupFailContent.localized }
  }

  private func showMainViewController(
    loadedUser: Observable<Response>
  ) -> Observable<Void> {
    return loadedUser
      .filter { $0.isSuccess }
      .map { _ in }
  }

  private func savePhoneNumber(
    loadedUser: Observable<Response>
  ) -> Observable<String> {
    return loadedUser
      .filter { $0.isSuccess }
      .map { $0.phoneNumber }
  }

  private func signup(
    textInput: TextInput
  ) -> Observable<Response> {
    let userName = textInput.name
      .filterNil()
      .filter { $0.isNotEmpty }

    let phoneNumber = textInput.phoneNumber
      .filterNil()
      .filter { $0.isNotEmpty }

    let password = textInput.password
      .filterNil()
      .filter { $0.isNotEmpty }


    return Observable.zip(
      userName,
      phoneNumber,
      password
    )
    .flatMapLatest { name, phoneNumber, password -> Observable<Bool> in
      return RxCouponData.signup(
        phoneNumber: phoneNumber,
        password: password,
        name: name
      )
      .asObservable()
    }
    .withLatestFrom(phoneNumber) { .init(isSuccess: $0, phoneNumber: $1) }
    .share()
  }

  private func loadUser(
    afterSignup: Observable<Response>
  ) -> Observable<Response> {
    return afterSignup
      .filter { $0.isSuccess }
      .flatMapLatest { signup -> Observable<Bool> in
        return RxCouponData.loadUserData(phoneNumber: signup.phoneNumber)
          .asObservable()
      }
      .withLatestFrom(afterSignup) { .init(isSuccess: $0, phoneNumber: $1.phoneNumber) }
      .share()
  }

}
