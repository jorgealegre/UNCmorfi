//
//  UNCmorfiUITests.swift
//  UNCmorfiUITests
//
//  Created by George Alegre on 19/12/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class UNCmorfiUITests: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDown() {
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        snapshot("0Launch")
    }
}
