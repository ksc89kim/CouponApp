//
//  CouponNetworkTests.swift
//  CouponAppTests
//
//  Created by 벨소프트 on 2018. 4. 9..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import XCTest
@testable import CouponApp

class CouponNetworkTests: XCTestCase {
    let password:String = "101010"
    let phoneNumber:String = "01028283032"
    let userName:String = "SEON"
    let userId:Int = 1
    let merchantId:Int = 1
    
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
        var isNetworkSucced:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestSignup(phoneNumber: self.phoneNumber, password: self.password, name:self.userName, complete: { isSucced in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
    }
    
    //회원 정보 가져오기
    func testRequestUserData() {
        var isNetworkSucced:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestUserData(phoneNumber: self.phoneNumber, complete: { isSucced in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
    }
    
    //패스워드 확인
    func testRequestCheckPassword() {
        var isNetworkSucced:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestCheckPassword(phoneNumber: self.phoneNumber, password: self.password, complete: { isSucced in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
    }
    
    // 가맹점 데이터 가져오기
    func testRequestGetMerchantData() {
        var isNetworkSucced:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestGetMerchantData(complete:{ isSucced in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
    }
    
    // 쿠폰 추가하기
    func testRequestInsertUserCoupon() {
        var isNetworkSucced:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestInsertUserCoupon(userId: userId, merchantId: merchantId, complete: { isSucced in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
    }
    
    // 쿠폰 확인하기
    func testRequestCheckUserCoupon() {
        var isNetworkSucced:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestCheckUserCoupon(userId: userId, merchantId: merchantId, complete: { isSucced in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
    }
    
    // 쿠폰 삭제하기
    func testRequestDeleteUserCoupon() {
        var isNetworkSucced:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestDeleteUserCoupon(userId: userId, merchantId: merchantId, complete: { isSucced in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
    }
    
    // 쿠폰 데이터 가져오기
    func testRequestUserCouponData() {
        var isNetworkSucced:Bool = false
        let userCouponList:[UserCouponModel?]? = nil
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestUserCouponData(userId: userId, complete: { isSucced, userCouponList  in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
        XCTAssertNil(userCouponList)
    }
    
    // 쿠폰 데이터 업데이트하기
    func testRequestUpdateUesrCoupon() {
          var isNetworkSucced:Bool = false
        let expectation = XCTestExpectation(description: "NETWORK ERROR")
        CouponNetwork.requestUpdateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: 1, complete: { isSucced in
            isNetworkSucced = isSucced
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(isNetworkSucced)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
