//
//  RespCodeModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

/// 응답 코드
struct ResponseCode: Codable {

  // MARK: - Define

  private enum ResponseCodeKeys: String, CodingKey {
    case isSuccess
  }

  // MARK: - Property

  var isSuccess:Bool

  // MARK: - Init

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ResponseCodeKeys.self)
    self.isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
  }
}
