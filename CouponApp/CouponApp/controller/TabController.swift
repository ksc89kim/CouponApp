//
//  TabController.swift
//  CouponApp
//
//  Created by kim sunchul on 13/07/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

typealias TabCallBack = (UIButton) -> Void

final class TabController {
  let tabButtonArray: [UIButton]?
  var currentIndex: Int = 0
  var callback: TabCallBack?

  init(buttonArray: [UIButton]){
    self.tabButtonArray = buttonArray
    for i in 0 ..< self.tabButtonArray!.count {
      let button:UIButton = self.tabButtonArray![i] as UIButton
      button.tag = i
      button.addTarget(self, action: #selector(self.onTab(button:)), for: .touchUpInside)
    }

    self.selectTab(index: self.currentIndex)
    self.executeCallBack(button: self.tabButtonArray![self.currentIndex])
  }

  @objc func onTab(button: UIButton) {
    self.selectTab(button: button)
    self.executeCallBack(button: button)
  }

  func selectTab(index: Int) {
    guard let buttonArray = self.tabButtonArray else {
      print("tabButtonArray nil")
      return
    }

    self.selectTab(button: buttonArray[index])
  }

  func selectTab(button: UIButton) {
    for tabButton in self.tabButtonArray! {
      if button == tabButton {
        tabButton.isSelected = true
        self.currentIndex = tabButton.tag
      } else {
        tabButton.isSelected = false
      }
    }
  }

  func executeCallBack(button: UIButton) {
    guard let tabCallback = self.callback else {
      print("callback nil")
      return
    }

    tabCallback(button)
  }
}
