//
//  MerchantDetailTransition.swift
//  CouponApp
//
//  Created by kim sunchul on 2022/03/15.
//  Copyright © 2022 kim sunchul. All rights reserved.
//

import UIKit

final class MerchantDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {

  // MARK: - Define

  enum AnimationType {
    case present
    case dismiss
  }

  private enum Animation {
    static let duration: CGFloat = 0.35
  }

  //MARK: - Property

  private let animationType: AnimationType

  init(type: AnimationType) {
    self.animationType = type
    super.init()
  }

  //MARK: - UIViewControllerAnimatedTransitioning Method

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Animation.duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch self.animationType {
    case .present: self.animationForPresent(using: transitionContext)
    case .dismiss: self.animationForDismiss(using: transitionContext)
    }
  }

  private func animationForPresent(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to) as? MerchantDetailViewController else { return }
    toViewController.prepareAnimation()
    toViewController.showAnimation(transitionContext: transitionContext)
  }

  private func animationForDismiss(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from) as? MerchantDetailViewController else { return }
    fromViewController.hideAnimation(transitionContext: transitionContext)
  }
}
