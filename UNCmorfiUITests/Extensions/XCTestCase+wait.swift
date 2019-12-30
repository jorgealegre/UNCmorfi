//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

extension XCTestCase {
    /// Helper function for waiting for elements to appear or disappear.
    /// - Parameters:
    ///     - for: the element to wait for
    ///     - toAppear: if false, we wait for the element to disappear. Defaults to true
    ///     - timeout: the amount of time to wait
    func wait(for element: XCUIElement, toAppear: Bool = true, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == \(toAppear)")

        // This will make the test runner continously evalulate the
        // predicate, and wait until it matches.
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
