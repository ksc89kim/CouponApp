//
//  CouponNetworkTests.swift
//  CouponAppTests
//
//  Created by 벨소프트 on 2018. 4. 9..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import XCTest

class CouponNetworkTests: XCTestCase {
    let password: String = "101010"
    let phoneNumber: String = "01028283032"
    let userName: String = "SEON"
    let userId: Int = 1
    let merchantId: Int = 1
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // 회원 가입하기
    func testRequestSignup() {
        var isNetworkSucceed: Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.signup(phoneNumber: self.phoneNumber, password: self.password, name:self.userName, complete: { isSucceed in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
    }
    
    //회원 정보 가져오기
    func testRequestUserData() {
        var isNetworkSucceed: Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.loadUserData(phoneNumber: self.phoneNumber, complete: { isSucceed in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
    }
    
    //패스워드 확인
    func testRequestCheckPassword() {
        var isNetworkSucceed: Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.checkPassword(phoneNumber: self.phoneNumber, password: self.password, complete: { isSucceed in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
    }
    
    // 가맹점 데이터 가져오기
    func testRequestGetMerchantData() {
        var isNetworkSucceed: Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.loadMerchantData(complete:{ isSucceed in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
    }
    
    // 쿠폰 추가하기
    func testRequestInsertUserCoupon() {
        var isNetworkSucceed: Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.insertUserCoupon(userId: userId, merchantId: merchantId, complete: { isSucceed in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
    }
    
    // 쿠폰 확인하기
    func testRequestCheckUserCoupon() {
        var isNetworkSucceed: Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.checkUserCoupon(userId: userId, merchantId: merchantId, complete: { isSucceed in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
    }
    
    // 쿠폰 삭제하기
    func testRequestDeleteUserCoupon() {
        var isNetworkSucceed:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.deleteUserCoupon(userId: userId, merchantId: merchantId, complete: { isSucceed in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
    }
    
    // 쿠폰 데이터 가져오기
    func testRequestUserCouponData() {
        var isNetworkSucceed: Bool = false
        let userCouponList: [UserCoupon?]? = nil
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.loadUserCouponData(userId: userId, complete: { isSucceed, userCouponList  in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
        XCTAssertNil(userCouponList)
    }
    
    // 쿠폰 데이터 업데이트하기
    func testRequestUpdateUesrCoupon() {
        var isNetworkSucceed: Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponRepository.updateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: 1, complete: { isSucceed in
            isNetworkSucceed = isSucceed
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucceed)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
