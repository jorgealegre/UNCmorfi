//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

public enum Services {
    public static var userStore: UserStore {
        guard !Settings.capturingScreenshots else {
            return MockUserStore.shared
        }

        return LocalUserStore.shared
    }
}
