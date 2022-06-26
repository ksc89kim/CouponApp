//
//  CouponView.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 8. 15..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

/// 쿠폰 그리기 뷰
/// - Draw를 통해 쿠폰을 그림, 원형 형태의 쿠폰.
final class CouponDrawView: UIView, CouponViewType {
  
  // MARK: - Define

  private enum AnimationKey {
    static let line = "line"
    static let strokeEnd = "strokeEnd"
  }

  // MARK: - UI Component

  private let backgroundCircleLayer = CAShapeLayer()
  private let ringThicknessLayer = CAShapeLayer()
  private let checkLayer = CAShapeLayer()

  // MARK: - Property

  var uiData: CouponUIType? {
    didSet {
      self.updateUI()
    }
  }

  // MARK: - Life Cycle

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  // MARK: - Draw & Update

  func updateUI() {
    self.setNeedsDisplay()
  }

  override func draw(_ rect: CGRect) {
    self.drawBackgroundCircle(rect)
    self.drawRingThickness(rect)
    self.drawCheck(rect)
  }

  private func drawBackgroundCircle(_ rect: CGRect) {
    guard let drawCoupon = uiData as? DrawCoupon else { return }

    self.backgroundCircleLayer.removeFromSuperlayer()
    self.backgroundCircleLayer.path = self.getBackgroundCirclePath(rect)
    self.backgroundCircleLayer.fillColor = UIColor.hexStringToUIColor(hex: drawCoupon.circleColor).cgColor
    self.layer.addSublayer(self.backgroundCircleLayer)
  }

  private func drawRingThickness(_ rect: CGRect) {
    guard let drawCoupon = uiData as? DrawCoupon else { return }
    guard drawCoupon.isRing else { self.ringThicknessLayer.removeFromSuperlayer(); return }

    self.ringThicknessLayer.path = self.getRingThicknessPath(rect, drawCoupon.ringThickness/2)
    self.ringThicknessLayer.fillColor = UIColor.clear.cgColor
    self.ringThicknessLayer.strokeColor = UIColor.hexStringToUIColor(hex: drawCoupon.ringColor).cgColor
    self.ringThicknessLayer.lineWidth = drawCoupon.ringThickness
    self.layer.addSublayer(self.ringThicknessLayer)
  }

  private func drawCheck(_ rect:CGRect) {
    guard let drawCoupon = uiData as? DrawCoupon else { return }
    guard drawCoupon.isUseCoupon else { self.checkLayer.removeFromSuperlayer(); return }

    self.checkLayer.path = getCheckPath(rect)
    self.checkLayer.strokeColor = UIColor.hexStringToUIColor(hex: drawCoupon.checkLineColor).cgColor
    self.checkLayer.lineWidth = drawCoupon.checkLineWidth
    self.checkLayer.lineCap = .round

    if drawCoupon.isAnimation{
      self.checkLayer.add(getCheckAnimation(), forKey: AnimationKey.line)
      drawCoupon.isAnimation = false
    }

    self.layer.addSublayer(self.checkLayer)
  }

  // MARK: - Get Method

  private func getBackgroundCirclePath(_ rect: CGRect) -> CGPath {
    return UIBezierPath(ovalIn: rect).cgPath
  }

  private func getRingThicknessPath(_ rect: CGRect, _ hw:CGFloat) -> CGPath {
    return UIBezierPath(ovalIn: rect.insetBy(dx: hw,dy: hw)).cgPath
  }

  private func getCheckPath(_ rect: CGRect) -> CGPath {
    var start:CGPoint = CGPoint(x: rect.maxX * 0.25, y: rect.maxY * 0.45)
    var end:CGPoint = CGPoint(x: rect.maxX * 0.5, y: rect.maxY * 0.65)

    let path = UIBezierPath()
    path.move(to: start)
    path.addLine(to: end)

    start = CGPoint(x: end.x, y: end.y)
    end = CGPoint(x: rect.maxX * 0.75, y: rect.maxY * 0.35)

    path.move(to: start)
    path.addLine(to: end)

    return path.cgPath
  }

  private func getCheckAnimation() -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: AnimationKey.strokeEnd)
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 0.3
    return animation
  }
}
