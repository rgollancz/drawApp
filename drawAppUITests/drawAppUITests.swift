//
//  drawAppUITests.swift
//  drawAppUITests
//
//  Created by Rosie Gollancz on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import XCTest

class drawAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testplayButton() {
        
        let app = XCUIApplication()
        let enterNameTextField = app.textFields["Enter name"]
        enterNameTextField.tap()
        enterNameTextField.typeText("m")
        app.typeText("\n")
        app.buttons["PLAY!"].tap()
    
    }
    
    func testwriteName() {
        
        let app = XCUIApplication()
        let enterNameTextField = app.textFields["Enter name"]
        enterNameTextField.tap()
        app.textFields["Enter name"].typeText("agatha")
        app.typeText("\n")
        XCTAssertNotNil(enterNameTextField)
    }
    
    func testNameShowsInSecondView() {
        let app = XCUIApplication()
        let enterNameTextField = app.textFields["Enter name"]
        enterNameTextField.tap()
        app.textFields["Enter name"].typeText("agatha")
        app.typeText("\n")
        app.buttons["PLAY!"].tap()
        let name = app.staticTexts["agatha"]
        XCTAssertNotNil(name)
    
        
    
    }
    
    
}
