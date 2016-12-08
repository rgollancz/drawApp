//
//  drawAppTests.swift
//  drawAppTests
//
//  Created by Rosie Gollancz on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import XCTest
@testable import drawApp

class drawAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
//        firstview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    override func tearDown() {
        super.tearDown()
    }

    func testbadText() {
        let firstview = FirstViewController()
        XCTAssertEqual(firstview.badText, nil, "Should be an empty string")
    }
    
   
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
