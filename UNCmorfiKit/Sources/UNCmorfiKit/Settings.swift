//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

public enum Settings {
    public static var capturingScreenshots: Bool {
        ProcessInfo.processInfo.arguments.contains("-capturing_screenshots")
    }
}
