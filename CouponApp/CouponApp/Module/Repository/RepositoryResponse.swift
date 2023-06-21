//
//  RepositoryResponse.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/05.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

enum ResponseKey: InjectionKey {
  typealias Value = ResponseType
}


protocol ResponseType: Injectable {
  var data: Codable? { get set }
}


struct RepositoryResponse: ResponseType {

  // MARK: - Property

  var data: Codable?
}
