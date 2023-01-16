//
//  DefaultError.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/12.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

enum DefaultError: LocalizedError {
  case networkError
  case noCouponError
  case notVaildUser
  case insertError
  case deleteError

  var errorDescription: String? {
    switch self {
    case .networkError: return "네트워크 오류입니다."
    case .noCouponError: return "쿠폰이 존재하지 않습니다."
    case .notVaildUser: return "유효한 유저가 아닙니다."
    case .insertError: return "쿠폰 추가에 실패하였습니다."
    case .deleteError: return "쿠폰 삭제에 실패하였습니다."
    }
  }
}
