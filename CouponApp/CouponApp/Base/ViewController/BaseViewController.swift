//
//  BaseViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/01.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

open class BaseViewController: UIViewController, Bindable {

  // MARK: - Property

  let disposeBag = DisposeBag()

  // MARK: - Init

  init(nibType: CouponNibName) {
    super.init(nibName: nibType.rawValue, bundle: nil)
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: - Life Cycle

  open override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
  }

  // MARK: - Bind

  open func bindInputs() {
  }

  open func bindOutputs() {
  }
}
