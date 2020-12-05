//
//  CustomPopupViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

final class CustomPopupViewController: UIViewController {
  
  @IBOutlet weak var popupView: RoundedView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var popupCenterYConstraint: NSLayoutConstraint!

  var okCallback:(() -> Void)?
  var contentText:String = ""
  var titleText:String = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setUI()
    self.delayAnimation()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  private func setUI() {
    self.titleLabel.text = titleText
    self.contentLabel.text = contentText
    self.popupView.alpha = 0
  }

  private func delayAnimation() {
    let deadlineTime = DispatchTime.now() + .milliseconds(100)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
      self?.showAnimation()
    })
  }

  func showAnimation() {
    self.showFadeInAnimation()
  }

  func showGiveAnimation() {
    self.popupView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    UIView.animate(
      withDuration: 1.0,
      delay: 0,
      usingSpringWithDamping: 0.3,
      initialSpringVelocity: 0,
      options: .curveEaseInOut,
      animations: { [weak self] in
        self?.popupView.transform = .identity
      }, completion: nil
    )
  }

  func showFadeInAnimation() {
    self.popupCenterYConstraint.constant = 0
    UIView.animate(withDuration: 0.35, animations: { [weak self] in
      self?.popupView.alpha = 1
      self?.view.layoutIfNeeded()
    })
  }

  @IBAction func onOk(_ sender: Any) {
    if self.okCallback != nil {
      self.okCallback!()
    }

    self.willMove(toParentViewController: nil)
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
}
