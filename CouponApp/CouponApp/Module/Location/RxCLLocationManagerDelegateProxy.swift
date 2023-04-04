//
//  RxCLLocationManagerDelegateProxy.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/24.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

final class RxCLLocationManagerDelegateProxy:
  DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
  DelegateProxyType,
  CLLocationManagerDelegate {

  static func registerKnownImplementations() {
    self.register { (location: CLLocationManager) -> RxCLLocationManagerDelegateProxy in
      return .init(
        parentObject: location,
        delegateProxy: self
      )
    }
  }

  static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
    return object.delegate
  }

  static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
    object.delegate = delegate
  }
}


extension Reactive where Base: CLLocationManager {

  var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
    return RxCLLocationManagerDelegateProxy.proxy(for: self.base)
  }

  var didUpdateLocationManager: Observable<CLLocationManager> {
    return self.delegate
      .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
      .compactMap { arguments -> CLLocationManager? in
        return arguments.first as? CLLocationManager
      }
  }
}
