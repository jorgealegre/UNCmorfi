//
// Copyright © 2019 George Alegre. All rights reserved.
//

import XCTest

class UsersUITests: TestCase {

    /// Test adding a user manually by typing the code.
    /// Test succeeds when we see the correct user loaded.
    func testAddUserManually() {
        // Given
        let code = "04756A29333C62D"
        let name = "Jorge Facundo Alegre"

        // When
        tab.navigateToUsers()
            .addUser()
            .manually()
            .typeBarcode(code)
            .done()

        // Then
        let nameLabel = usersPage
            .user(at: 0)
            .get(.name)

        wait(for: nameLabel, timeout: 10)
        XCTAssertEqual(nameLabel.label, name)
    }
}
