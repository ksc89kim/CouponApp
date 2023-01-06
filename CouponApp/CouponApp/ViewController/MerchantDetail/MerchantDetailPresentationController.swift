//
//  MerchantDetailPresentationController.swift
//  CouponApp
//
//  Created by kim sunchul on 2022/03/14.
//  Copyright © 2022 kim sunchul. All rights reserved.
//

import UIKit

final class MerchantDetailPresentationController: UIPresentationController {

  //MARK: - UI Component

  private let dimmedVew: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  //MARK: - Override Method

  override var shouldRemovePresentersView: Bool {
      return false
  }

  override func presentationTransitionWillBegin() {
    guard let containerView = self.containerView else { return }
    containerView.addSubview(self.dimmedVew)
    NSLayoutConstraint.activate([
      self.dimmedVew.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
      self.dimmedVew.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
      self.dimmedVew.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
      self.dimmedVew.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
    ])
    self.dimmedVew.alpha = 0

    containerView.addSubview(self.presentedViewController.view)
    self.presentedViewController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.presentedViewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
      self.presentedViewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
      self.presentedViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
      self.presentedViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
    ])

    containerView.layoutIfNeeded()

    self.presentingViewController.beginAppearanceTransition(false, animated: false)
    self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
      self.dimmedVew.alpha = 0.5
    }, completion: { context in
    })
  }

  override func presentationTransitionDidEnd(_ completed: Bool) {
    self.presentingViewController.endAppearanceTransition()
  }

  override func dismissalTransitionWillBegin() {
    self.presentingViewController.beginAppearanceTransition(true, animated: true)
    self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
      self.dimmedVew.alpha = 0.0
    }, completion: { context in
    })
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    self.presentingViewController.endAppearanceTransition()
    if completed {
      self.dimmedVew.removeFromSuperview()
    }
  }
}
