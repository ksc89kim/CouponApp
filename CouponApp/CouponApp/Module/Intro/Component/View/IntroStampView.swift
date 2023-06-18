//
//  IntroTitleView.swift
//  CouponApp
//
//  Created by kim sunchul on 11/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

final class IntroStampView: UIView {

  // MARK: - Define

  private enum Metric {
    static let stampPathSize = CGSize(
      width: 160.08163265306,
      height: 169.222222222223
    )
  }

  typealias Completion = () -> Void

  private enum AnimationKey {
    static let line = "line"
    static let strokeEnd = "strokeEnd"
  }

  // MARK: - UI Component

  private var drawLayer = CAShapeLayer()
  @Inject(IntroStampDrawPathKey.self)
  private var introPath: IntroStampDrawPathable

  // MARK: - Property

  var completion: Completion?

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setup()
  }

  // MARK: - Life Cycle

  override func draw(_ rect: CGRect) {
    self.introPath.setRate(parentRect: rect)
    self.introPath.draw()
    self.setDrawLayer()
    self.drawLayer.add(
      self.getStrokeAnimation(),
      forKey: AnimationKey.line
    )
  }

  // MARK: - Set Method

  private func setup() {
    self.layer.addSublayer(self.drawLayer)
    self.introPath.configure(
      drawRect: CGRect(
        origin: CGPoint.zero,
        size: Metric.stampPathSize
      ),
      parentRect: CGRect.zero
    )
  }

  private func setDrawLayer() {
    self.drawLayer.path = self.introPath.getCGPath()
    self.drawLayer.strokeEnd = 1
    self.drawLayer.lineWidth = 1
    self.drawLayer.strokeColor = UIColor.white.cgColor
    self.drawLayer.fillColor = UIColor.clear.cgColor
  }

  // MARK: - Get Method

  private func getStrokeAnimation() -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: AnimationKey.strokeEnd)
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 2
    animation.delegate = self
    return animation
  }
}


extension IntroStampView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if (flag) {
      guard let callback = self.completion else {
        return
      }
      callback()
    }
  }
}
