//
//  YenDonTests.swift
//  YenDonTests
//
//  Created by 横島健一 on 2017/06/20.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import XCTest
@testable import YenDon

class YenDonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testApi() {
        let ex = expectation(description: "Api")
        let api = Api()
        api.request(success: { (data: Dictionary<String, Any>) in
            debugPrint(data)
            ex.fulfill()
            XCTAssertTrue(data["error"] == nil)
            
        }, fail: { (error: Error?) in
            print(error)
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)

    }
    
    func testApiWithDupilicateKey(){
        let ex = expectation(description: "Api")
        let api = Api(pairs: ["JPYVND","JPYVND","USDVND"])
        api.request(success: { (data: Dictionary<String, Any>) in
            debugPrint(data)
            ex.fulfill()
            XCTAssertTrue(data["error"] == nil)
            
        }, fail: { (error: Error?) in
            print(error)
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
