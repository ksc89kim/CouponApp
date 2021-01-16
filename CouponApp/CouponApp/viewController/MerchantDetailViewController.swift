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

  private enum Metric {
    static let originalHeaderHeight: CGFloat = 163
    static let maxPercent: CGFloat = 100
    static let titleFontSize: CGFloat = 30
    static let cellFontSize: CGFloat = 17
  }

  private enum Font {
    static let bold = "NotoSansCJKkr-Bold"
    static let regular = "NotoSansCJKkr-Regular"
  }

  @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var headerWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!

  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var introduceLabel: UILabel!
  @IBOutlet weak var actionButton: UIButton!
  let titleLabel: MerchantAnimatedLabel = {
    let label = MerchantAnimatedLabel()
    label.font = UIFont(name: Font.bold, size: Metric.titleFontSize)
    label.textColor = UIColor.white
    label.cellFont = UIFont(name: Font.regular, size: Metric.cellFontSize)
    return label
  }()

  var merchantDetail = MerchantDetail()
  private var isAnimation = false
  private var _percent: CGFloat = 0.0
  private var percent: CGFloat {
    get {
      return _percent
    }
    set(newValue){
      if newValue > 0 && newValue < Metric.maxPercent {
        self._percent = newValue
      } else if newValue >= Metric.maxPercent {
        self._percent = Metric.maxPercent
      } else {
        self._percent = 0
      }

      if !self.isAnimation {
        self.setAnimationPercent(percent: self._percent)
      }
    }
  }
  private let viewModel = MerchantDetailViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setUI()
    self.setHeaderHeight()
    self.setPanGesture()

    self.viewModel.inputs.loadData.onNext(self.merchantDetail)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.setAnimationPercent(percent: 0)
    self.openAnimation()
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

    self.viewModel.outputs.title
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] title in
        self?.titleLabel.text = title
        self?.titleLabel.sizeToFit()
      })
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.buttonTitle
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.actionButton.rx.title(for: .normal))
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.introduce
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.introduceLabel.rx.text)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.headerBackgroundColor
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.headerView.rx.backgroundColor)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.headerImage
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.headerImageView.rx.cropRoundedImage)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showCustomPopup
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showCustomPopup)
      .disposed(by: self.disposeBag)
  }

  // MARK: - 제스처 세팅

  private func setPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    self.view.addGestureRecognizer(panGesture)
  }

  // MARK: - UI 세팅

  private func setUI(){
    self.headerView.addSubview(self.titleLabel)
  }

  // MARK: - 헤더 높이 설정

  private func setHeaderHeight() {
    self.merchantDetail.originalHeaderHeight = self.headerHeightConstraint.constant
  }

  // MARK: - 애니메이션

  private func setAnimationPercent(percent: CGFloat) {
    self.setHeaderAnimationPercent(percent: percent)
    self.setContentAnimationPercent(percent: percent)
  }

  private func setHeaderAnimationPercent(percent: CGFloat) {
    let haederMovePosition = (self.merchantDetail.positionY * percent) / 100
    let headerWidth = ((self.view.frame.width - self.merchantDetail.getCellWidth()) * percent) / 100
    let headerHeight = ((Metric.originalHeaderHeight - self.merchantDetail.getCellHeight()) * percent) / 100

    self.headerTopConstraint.constant = self.merchantDetail.positionY - haederMovePosition
    self.headerWidthConstraint.constant = self.merchantDetail.getCellWidth() + headerWidth
    self.headerHeightConstraint.constant = self.merchantDetail.getCellHeight() + headerHeight

    self.titleLabel.setPercent(percent: percent)
    self.titleLabel.setPosition(x: self.headerWidthConstraint.constant - 15, y: 20)
  }

  private func setContentAnimationPercent(percent: CGFloat) {
    let contentMovePosition = ((self.view.frame.height - Metric.originalHeaderHeight) * percent) / 100
    self.contentTopConstraint.constant = (self.view.frame.height - Metric.originalHeaderHeight) - contentMovePosition
  }

  private func moveUI(direction: PanDirection) {
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

  private func moveAnimation(state: UIGestureRecognizer.State) {
    switch state {
    case .ended,.cancelled, .failed:
      if self._percent < 90 {
        self.closeAnimation()
      } else {
        self.openAnimation()
      }
      break
    default:
      break
    }
  }

  private func openAnimation(){
    self.isAnimation = true
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: { [weak self] in
      self?.setAnimationPercent(percent: Metric.maxPercent)
      self?.view.layoutIfNeeded()
    }, completion: { [weak self] (isSuccess) in
      if isSuccess {
        self?.percent = Metric.maxPercent
        self?.isAnimation = false
      }
    })
  }

  private func closeAnimation(){
    self.isAnimation = true
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: { [weak self] in
      self?.setAnimationPercent(percent: 0)
      self?.view.layoutIfNeeded()
    }, completion: { [weak self] (isSucess) in
      if isSucess {
        self?.percent = 0
        self?.isAnimation = false
        self?.view.removeFromSuperview()
        self?.willMove(toParentViewController: nil)
        self?.removeFromParentViewController()
      }
    })
  }

  // MARK: - 제스처 기능

  @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
    if (sender.direction == .down) {
      self.closeAnimation()
    }
  }

  @objc func handlePan(_ sender:UIPanGestureRecognizer) {
    guard !self.isAnimation else {
      return
    }

    self.moveUI(direction: sender.direction!)
    self.moveAnimation(state: sender.state)
  }

}
