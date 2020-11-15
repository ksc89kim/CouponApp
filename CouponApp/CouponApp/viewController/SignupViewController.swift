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
final class SignupViewController: CouponViewController {

  enum Text {
    static let namePlaceHolder = "UserName"
    static let phoneNumberPlaceHolder = "PhoneNumber"
    static let passwordPlaceHolder = "Password"
  }

  // MARK: - UI Component

  @IBOutlet weak var nameTextInput: CouponAnimatedTextInput!
  @IBOutlet weak var phoneNumberTextInput: CouponAnimatedTextInput!
  @IBOutlet weak var passwordTextInput: CouponAnimatedTextInput!
  @IBOutlet weak var continueButton: RoundedButton!

  // MARK: - Property

  private let maxPhoneNumber: Int = 11
  private let viewModel = SignupViewModel()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
  }

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

  override func bind() {
    super.bind()

    self.nameTextInput.rx.text
      .bind(to: self.viewModel.state.userName)
      .disposed(by: self.disposeBag)

    self.phoneNumberTextInput.rx.text
      .bind(to: self.viewModel.state.userPhoneNumber)
      .disposed(by: self.disposeBag)

    self.passwordTextInput.rx.text
      .bind(to: self.viewModel.state.userPassword)
      .disposed(by: self.disposeBag)

    self.continueButton.rx.tap
      .asObservable()
      .bind(to: self.viewModel.action.onSingup)
      .disposed(by: self.disposeBag)

    self.viewModel.state.showCustomPopup
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showCustomPopup)
      .disposed(by: self.disposeBag)

    self.viewModel.state.showMainViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showMainViewController)
      .disposed(by: self.disposeBag)

    self.viewModel.state.savePhoneNumber
      .subscribe(onNext: { phoneNumber in
        UserDefaults.standard.set(phoneNumber, forKey: DefaultKey.phoneNumber.rawValue)
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Etc Function

  fileprivate func showMainViewController() {
    let mainViewController:UIViewController = self.createViewController(storyboardName: CouponStoryBoardName.main.rawValue)
    mainViewController.modalPresentationStyle = .fullScreen
    self.present(mainViewController, animated: true, completion: nil)
  }

  // MARK: - Get Function

  private func getCurrentTextInputCount(animatedTextInput: CouponAnimatedTextInput) -> Int {
    return animatedTextInput.text?.count ?? 0
  }
}

extension SignupViewController: CouponAnimatedTextInputDelegate {

  func animatedTextInput(
    animatedTextInput: CouponAnimatedTextInput,
    shouldChangeCharactersInRange range: NSRange,
    replacementString string: String
  ) -> Bool {
    if range.length + range.location > self.getCurrentTextInputCount(animatedTextInput: animatedTextInput) {
      return false
    }
    if animatedTextInput == self.phoneNumberTextInput {
      let newLength = self.getCurrentTextInputCount(animatedTextInput: animatedTextInput) + string.count - range.length
      return newLength <= self.maxPhoneNumber
    }

    return true
  }
  
}

extension Reactive where Base: SignupViewController {

  var showMainViewController: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.showMainViewController()
    }
  }
}
