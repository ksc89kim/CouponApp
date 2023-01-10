//
//  CouponAnimatedTextInput.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/01.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AnimatedTextInput

protocol CouponAnimatedTextInputDelegate: class {
   func animatedTextInput(
     animatedTextInput: CouponAnimatedTextInput,
     shouldChangeCharactersInRange range: NSRange,
     replacementString string: String
   ) -> Bool
}


final class CouponAnimatedTextInput: UIView {

  // MARK: - Defines

  typealias AnimatedTextInputType = AnimatedTextInputFieldConfigurator.AnimatedTextInputType

  // MARK: - Property

  private let textInput = AnimatedTextInput()
  weak var delegate: CouponAnimatedTextInputDelegate?
  fileprivate let textSubject = BehaviorRelay<String?>(value: nil)

  var placeHolderText: String {
    get {
      return self.textInput.placeHolderText
    }
    set {
      self.textInput.placeHolderText = newValue
    }
  }

  var style: AnimatedTextInputStyle {
    get {
      return self.textInput.style
    }
    set {
      self.textInput.style = newValue
    }
  }

  var type: AnimatedTextInputType {
    get {
      return self.textInput.type
    }
    set {
      self.textInput.type = newValue
    }
  }

  var text: String? {
    get {
      return self.textInput.text
    }
    set {
      self.textInput.text = newValue
    }
  }

  // MARK: - init

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.textInput)
    self.textInput.delegate = self
    self.makeConstraint()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    self.addSubview(self.textInput)
    self.textInput.delegate = self
    self.makeConstraint()
  }

  // MARK: - Layout

  private func makeConstraint() {
    self.textInput.translatesAutoresizingMaskIntoConstraints = false
    self.textInput.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    self.textInput.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    self.textInput.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    self.textInput.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
}


extension CouponAnimatedTextInput: AnimatedTextInputDelegate {
  func animatedTextInputDidChange(animatedTextInput: AnimatedTextInput) {
    self.textSubject.accept(animatedTextInput.text)
  }

  func animatedTextInput(
    animatedTextInput: AnimatedTextInput,
    shouldChangeCharactersInRange range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let delegate = self.delegate else {
      return true
    }

    return delegate.animatedTextInput(
      animatedTextInput: self,
      shouldChangeCharactersInRange: range,
      replacementString: string
    )
  }
}


extension Reactive where Base: CouponAnimatedTextInput {
  var text: Observable<String?> {
    return base.textSubject.asObservable()
  }
}



