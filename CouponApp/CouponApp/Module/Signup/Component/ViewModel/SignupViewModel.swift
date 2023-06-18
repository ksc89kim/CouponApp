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

final class SignupViewModel: SignupViewModelType {

  // MARK: - Define

  private struct Subject {
    let onSingup = PublishSubject<Void>()
    let userName = PublishSubject<String?>()
    let userPhoneNumber = PublishSubject<String?>()
    let userPassword = PublishSubject<String?>()
    let error = PublishSubject<Error>()
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

  // MARK: - Property

  var inputs: SignupInputType
  var outputs: SignupOutputType?

  // MARK: - Init

  init() {

    let subject = Subject()

    self.inputs = SignupInputs(
      onSingup: subject.onSingup.asObserver(),
      userName: subject.userName.asObserver(),
      userPhoneNumber: subject.userPhoneNumber.asObserver(),
      userPassword: subject.userPassword.asObserver()
    )


    let textInput = self.getTextInput(onSignup: subject.onSingup.asObservable(), subject: subject)

    let afterSignup = self.signup(textInput: textInput, errorObserver: subject.error.asObserver())

    let loadedUser = self.loadUser(afterSignup: afterSignup, errorObserver: subject.error.asObserver())

    let showCustomPopup = self.showCustomPopup(
      textInput: textInput,
      error: subject.error.asObservable()
    )

    let showMainViewController = self.showMainViewController(loadedUser: loadedUser)

    self.outputs = SignupOutputs(
      showCustomPopup: showCustomPopup,
      showMainViewController: showMainViewController
    )
  }


  // MARK: - Method

  private func getTextInput(onSignup: Observable<Void>, subject: Subject) -> TextInput {
    let userName = self.getStringWhenOnSignup(onSignup: onSignup, text: subject.userName.asObservable())
    let phoneNumber = self.getStringWhenOnSignup(onSignup: onSignup, text: subject.userPhoneNumber.asObservable())
    let password = self.getStringWhenOnSignup(onSignup: onSignup, text: subject.userPassword.asObservable())

    return .init(
      name: userName,
      phoneNumber: phoneNumber,
      password: password
    )
  }

  private func getStringWhenOnSignup(onSignup: Observable<Void>, text: Observable<String?>) -> Observable<String?> {
    return onSignup
      .withLatestFrom(text)
      .share()
  }

  private func showCustomPopup(
    textInput: TextInput,
    error: Observable<Error>
  ) -> Observable<CustomPopupConfigurable> {

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

  private func networkFailMessage(error: Observable<Error>) -> Observable<String> {
    return error
    .map { _ in Text.signupFailContent.localized }
  }

  private func showMainViewController(loadedUser: Observable<String>) -> Observable<Void> {
    return loadedUser
      .map { _ in }
  }

  private func signup(textInput: TextInput, errorObserver: AnyObserver<Error>) -> Observable<String> {
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
    .flatMapLatest { name, phoneNumber, password -> Observable<String> in
      return CouponRepository.instance.rx.signup(
        phoneNumber: phoneNumber,
        password: password,
        name: name
      )
      .asObservable()
      .suppressAndFeedError(into: errorObserver)
      .map { _ in  phoneNumber}
    }
    .share()
  }

  private func loadUser(afterSignup: Observable<String>, errorObserver: AnyObserver<Error>) -> Observable<String> {
    return afterSignup
      .flatMapLatest { phoneNumber -> Observable<String> in
        return CouponRepository.instance.rx.loadUserData(phoneNumber: phoneNumber)
          .asObservable()
          .do(onNext: { (response: RepositoryResponse) in
            guard let user = response.data as? User else { return }
            Me.instance.update(user: user)
          })
          .suppressAndFeedError(into: errorObserver)
          .map { _ in phoneNumber }
      }
      .do(onNext: { (phoneNumber: String) in
        Phone().saveNumber(phoneNumber)
      })
      .share()
  }

}
