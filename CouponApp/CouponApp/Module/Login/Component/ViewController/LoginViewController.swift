//
//  LoginViewController.swift
//  CouponApp
//
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift

///  로그인 뷰컨트롤러
final class LoginViewController: BaseViewController, MainPresent {

  // MARK: - Define

  private enum Text {
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

  @IBOutlet weak var phoneNumberTextInput: CouponAnimatedTextInput!
  @IBOutlet weak var passwordTextInput: CouponAnimatedTextInput!
  @IBOutlet weak var loginButton: RoundedButton!
  @IBOutlet weak var signupButton: UIButton!

  // MARK: - Property

  @Inject(LoginViewModelKey.self)
  private var viewModel: LoginViewModelType
  var merchantList: (any MerchantListable)?

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
  }

  // MARK: - Touch

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  // MARK: - Set Method

  private func setUI(){
    self.setPhoneNumberTextInput()
    self.setPasswordTextInput()
  }

  private func setPhoneNumberTextInput() {
    self.phoneNumberTextInput.placeHolderText = Text.phoneNumberPlaceHolder
    self.phoneNumberTextInput.type = .phone;
    self.phoneNumberTextInput.delegate = self
    self.phoneNumberTextInput.style = DIContainer.resolve(for: TextInputStyleKey.self)
  }
  
  private func setPasswordTextInput() {
    self.passwordTextInput.placeHolderText = Text.passwordPlaceHolder
    self.passwordTextInput.type = .password(toggleable: true)
    self.passwordTextInput.style = DIContainer.resolve(for: TextInputStyleKey.self)
  }

  // MARK: - Unwind Method

  @IBAction func unwindLoginViewController(segue:UIStoryboardSegue) {
    if segue.identifier == CouponIdentifier.unwindLoginViewController.rawValue {
    }
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()

    self.phoneNumberTextInput.rx.text
      .bind(to: self.viewModel.inputs.userPhoneNumber)
      .disposed(by: self.disposeBag)

    self.passwordTextInput.rx.text
      .bind(to: self.viewModel.inputs.userPassword)
      .disposed(by: self.disposeBag)

    self.loginButton.rx.tap
      .asObservable()
      .bind(to: self.viewModel.inputs.onLogin)
      .disposed(by: self.disposeBag)

    self.signupButton.rx.tap
      .asObservable()
      .bind(to: self.viewModel.inputs.onSingup)
      .disposed(by: self.disposeBag)
  }

  override func bindOutputs() {
    super.bindOutputs()

    self.viewModel.outputs?.showCustomPopup
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showCustomPopup)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.showMainViewController
      .compactMap { [weak self] _ -> (any MerchantListable)? in self?.merchantList }
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showMainViewController)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.showSignupViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showSignupViewController)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Get Method

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

  // MARK: - Navigation

  fileprivate func showSignupViewController() {
    self.performSegue(withIdentifier: CouponIdentifier.showSignupViewController.rawValue, sender: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == CouponIdentifier.showSignupViewController.rawValue,
       let signupViewController = segue.destination as? SignupViewController {
      signupViewController.merchantList = self.merchantList
    }
  }
}


extension LoginViewController: CouponAnimatedTextInputDelegate {
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


extension Reactive where Base: LoginViewController {
  var showSignupViewController: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.showSignupViewController()
    }
  }
}
