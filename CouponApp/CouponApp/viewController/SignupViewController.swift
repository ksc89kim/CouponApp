//
//  SignupViewController.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import AnimatedTextInput

/// 가입 뷰컨트롤러
final class SignupViewController: BaseViewController {

  private enum Text {
    static let namePlaceHolder = "UserName"
    static let phoneNumberPlaceHolder = "PhoneNumber"
    static let passwordPlaceHolder = "Password"
  }

  private enum Limit {
    static let phoneNumber = 11
  }

  private struct CouponAnimatedText {
    let animatedTextInput: CouponAnimatedTextInput
    let range: NSRange
    let replacementString: String
  }

  // MARK: - UI Component

  @IBOutlet weak var nameTextInput: CouponAnimatedTextInput!
  @IBOutlet weak var phoneNumberTextInput: CouponAnimatedTextInput!
  @IBOutlet weak var passwordTextInput: CouponAnimatedTextInput!
  @IBOutlet weak var continueButton: RoundedButton!

  // MARK: - Property

  private let viewModel = SignupViewModel()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
  }

  // MARK: - Touch

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  // MARK: - Set Function

  private func setUI(){
    self.setNameTextInput()
    self.setPhoneNumberTextInput()
    self.setPasswordTextInput()
  }

  private func setNameTextInput() {
    self.nameTextInput.placeHolderText = Text.namePlaceHolder
    self.nameTextInput.style = CustomTextInputStyle()
  }

  private func setPhoneNumberTextInput() {
    self.phoneNumberTextInput.placeHolderText = Text.phoneNumberPlaceHolder
    self.phoneNumberTextInput.type = .phone;
    self.phoneNumberTextInput.delegate = self
    self.phoneNumberTextInput.style = CustomTextInputStyle()
  }

  private func setPasswordTextInput() {
    self.passwordTextInput.placeHolderText = Text.passwordPlaceHolder
    self.passwordTextInput.type = .password(toggleable: true)
    self.passwordTextInput.style = CustomTextInputStyle()
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()

    self.nameTextInput.rx.text
      .bind(to: self.viewModel.inputs.userName)
      .disposed(by: self.disposeBag)

    self.phoneNumberTextInput.rx.text
      .bind(to: self.viewModel.inputs.userPhoneNumber)
      .disposed(by: self.disposeBag)

    self.passwordTextInput.rx.text
      .bind(to: self.viewModel.inputs.userPassword)
      .disposed(by: self.disposeBag)

    self.continueButton.rx.tap
      .asObservable()
      .bind(to: self.viewModel.inputs.onSingup)
      .disposed(by: self.disposeBag)
  }

  override func bindOutputs() {
    super.bindOutputs()

    self.viewModel.outputs.showCustomPopup
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showCustomPopup)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showMainViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showMainViewController)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.savePhoneNumber
      .subscribe(onNext: { phoneNumber in
        UserDefaults.standard.set(phoneNumber, forKey: DefaultKey.phoneNumber.rawValue)
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Get Function

  private func getCurrentTextInputCount(animatedTextInput: CouponAnimatedTextInput) -> Int {
    return animatedTextInput.text?.count ?? 0
  }

  // MARK: - Text Limit

  private func isCurrentLengthLimit(
    data: CouponAnimatedText
  ) -> Bool {
    return data.range.length + data.range.location > self.getCurrentTextInputCount(animatedTextInput: data.animatedTextInput)
  }

  private func isNewLengthLimit(
    data: CouponAnimatedText,
    maxLimit: Int
  ) -> Bool {
    var newLength = self.getCurrentTextInputCount(animatedTextInput: data.animatedTextInput) + data.replacementString.count
    newLength -= data.range.length
    return newLength <= maxLimit
  }
}

extension SignupViewController: CouponAnimatedTextInputDelegate {

  func animatedTextInput(
    animatedTextInput: CouponAnimatedTextInput,
    shouldChangeCharactersInRange range: NSRange,
    replacementString string: String
  ) -> Bool {
    let data = CouponAnimatedText(
      animatedTextInput: animatedTextInput,
      range: range,
      replacementString: string
    )

    if self.isCurrentLengthLimit(data: data) {
      return false
    }

    if animatedTextInput == self.phoneNumberTextInput {
      return self.isNewLengthLimit(data: data, maxLimit: Limit.phoneNumber)
    }

    return true
  }
  
}
