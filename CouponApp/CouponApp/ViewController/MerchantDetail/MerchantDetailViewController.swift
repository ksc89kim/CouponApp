//
//  MerchantInfoViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 3. 30..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MerchantDetailViewController: BaseViewController {

  //MARK: - Define

  private enum Metric {
    static let originalHeaderHeight: CGFloat = 163
    static let titleFontSize: CGFloat = 30
    static let cellFontSize: CGFloat = 17
    static let titleLabelPosition: CGPoint = .init(x: 15, y: 20)
  }

  private enum Constant {
    static let maxPercent: CGFloat = 100
    static let dimissPercent: CGFloat = 90
  }

  private enum Font {
    static let bold = "NotoSansCJKkr-Bold"
    static let regular = "NotoSansCJKkr-Regular"
  }

  //MARK: - Constraint

  @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var headerWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!

  //MARK: - UI Component

  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var introduceLabel: UILabel!
  @IBOutlet weak var actionButton: UIButton!
  fileprivate let titleLabel: MerchantAnimatedLabel = {
    let label = MerchantAnimatedLabel()
    label.font = UIFont(name: Font.bold, size: Metric.titleFontSize)
    label.textColor = UIColor.white
    label.cellFont = UIFont(name: Font.regular, size: Metric.cellFontSize)
    return label
  }()

  //MARK: - Property

  fileprivate var cellTopViewFrame: CGRect = .zero
  fileprivate var cellCornerRadius: CGFloat = .zero
  private var isAnimation = false
  private var _percent: CGFloat = .zero
  private var percent: CGFloat {
    get {
      return _percent
    }
    set(newValue){
      if newValue > 0 && newValue < Constant.maxPercent {
        self._percent = newValue
      } else if newValue >= Constant.maxPercent {
        self._percent = Constant.maxPercent
      } else {
        self._percent = .zero
      }

      if !self.isAnimation {
        self.setAnimationPercent(percent: self._percent)
      }
    }
  }
  private let viewModel: MerchantDetailViewModelType

  //MARK: - Init

  init(viewModel: MerchantDetailViewModelType) {
    self.viewModel = viewModel
    super.init(nibType: .merchantDetailViewController)
    self.modalPresentationStyle = .custom
    self.transitioningDelegate = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setUI()
    self.setPanGesture()
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()

    self.actionButton.rx.tap
      .bind(to: self.viewModel.inputs.actionFromBottom)
      .disposed(by: self.disposeBag)
  }

  override func bindOutputs() {
    super.bindOutputs()

    self.viewModel.outputs?.cellTopViewFrame
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.cellTopViewFrame)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.cellCornerRadius
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.cellCornerRadius)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.title
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.title)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.buttonTitle
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.actionButton.rx.title(for: .normal))
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.introduce
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.introduceLabel.rx.text)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.headerBackgroundColor
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.headerView.rx.backgroundColor)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.headerImageURL
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.headerImageURL)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?.showCustomPopup
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showCustomPopup)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Set

  private func setPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    self.view.addGestureRecognizer(panGesture)
  }

  private func setUI(){
    self.headerView.addSubview(self.titleLabel)
    self.headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }

  // MARK: - Animation Function

  func prepareAnimation() {
    self.setAnimationPercent(percent: .zero)
  }

  private func setAnimationPercent(percent: CGFloat) {
    self.setHeaderAnimationPercent(percent: percent)
    self.setContentAnimationPercent(percent: percent)
  }

  private func setHeaderAnimationPercent(percent: CGFloat) {
    let haederMovePosition = (self.cellTopViewFrame.origin.y * percent) / Constant.maxPercent
    let headerWidth = ((self.view.frame.width - self.cellTopViewFrame.width) * percent) / Constant.maxPercent
    let headerHeight = ((Metric.originalHeaderHeight - self.cellTopViewFrame.height) * percent) / Constant.maxPercent
    let headerCornerRadius = (self.cellCornerRadius * (Constant.maxPercent - percent)) / Constant.maxPercent

    self.headerTopConstraint.constant = self.cellTopViewFrame.origin.y - haederMovePosition
    self.headerWidthConstraint.constant = self.cellTopViewFrame.width + headerWidth
    self.headerHeightConstraint.constant = self.cellTopViewFrame.height + headerHeight
    self.headerView.layer.cornerRadius = headerCornerRadius

    self.titleLabel.setPercent(percent)
    self.titleLabel.setPosition(
      .init(
        x: self.headerWidthConstraint.constant - Metric.titleLabelPosition.x,
        y: Metric.titleLabelPosition.y
      )
    )
  }

  private func setContentAnimationPercent(percent: CGFloat) {
    let contentMovePosition = ((self.view.frame.height - Metric.originalHeaderHeight) * percent) / Constant.maxPercent
    self.contentTopConstraint.constant = (self.view.frame.height - Metric.originalHeaderHeight) - contentMovePosition
  }

  func showAnimation(transitionContext: UIViewControllerContextTransitioning? = nil) {
    self.isAnimation = true
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: { [weak self] in
      self?.setAnimationPercent(percent: Constant.maxPercent)
      self?.view.layoutIfNeeded()
    }, completion: { [weak self] (finished: Bool) in
      if finished {
        self?.percent = Constant.maxPercent
        self?.isAnimation = false
      }
      transitionContext?.completeTransition(finished)
    })
  }

  func hideAnimation(transitionContext: UIViewControllerContextTransitioning? = nil) {
    self.isAnimation = true
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: { [weak self] in
      self?.setAnimationPercent(percent: 0)
      self?.view.layoutIfNeeded()
    }, completion: { [weak self] (finished: Bool) in
      if finished {
        self?.percent = .zero
        self?.isAnimation = false
      }
      transitionContext?.completeTransition(finished)
    })
  }

  // MARK: - Gesture

  @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
    if (sender.direction == .down) {
      self.hideAnimation()
    }
  }

  @objc func handlePan(_ sender:UIPanGestureRecognizer) {
    guard !self.isAnimation else {
      return
    }

    self.moveUI(direction: sender.direction)
    self.endGesture(state: sender.state)
  }

  private func moveUI(direction: PanDirection?) {
    guard let direction = direction else {
      return
    }

    switch direction {
    case PanDirection.down:
      self.percent -= 1
      break
    case PanDirection.up:
      self.percent += 1
      break
    default:
      break
    }
  }

  private func endGesture(state: UIGestureRecognizer.State) {
    switch state {
    case .ended,.cancelled, .failed:
      if self._percent < Constant.dimissPercent {
        self.dismiss(animated: true, completion: nil)
      } else {
        self.showAnimation()
      }
      break
    default:
      break
    }
  }
}


extension MerchantDetailViewController: UIViewControllerTransitioningDelegate {

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return MerchantDetailTransition(type: .present)
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return MerchantDetailTransition(type: .dismiss)
  }

  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    return MerchantDetailPresentationController(
      presentedViewController: presented,
      presenting: presenting
    )
  }
}


private extension Reactive where Base: MerchantDetailViewController {
  var title: Binder<String> {
    return Binder(self.base) { (viewController: MerchantDetailViewController, title: String) in
      viewController.titleLabel.text = title
      viewController.titleLabel.sizeToFit()
    }
  }

  var headerImageURL: Binder<URL?> {
    return Binder(self.base) { (viewController: MerchantDetailViewController, url: URL?) in
      viewController.headerImageView.kf.setImage(with: url, completionHandler: { [weak viewController] result in
        viewController?.headerImageView.cropRoundedImage()
      })
    }
  }

  var cellTopViewFrame: Binder<CGRect> {
    return Binder(self.base) { (viewController: MerchantDetailViewController, frame: CGRect) in
      viewController.cellTopViewFrame = frame
    }
  }

  var cellCornerRadius: Binder<CGFloat> {
    return Binder(self.base) { (viewController: MerchantDetailViewController, cornerRadius: CGFloat) in
      viewController.cellCornerRadius = cornerRadius
    }
  }
}
