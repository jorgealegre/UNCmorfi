//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import AlamofireImage
import UNCmorfiKit

@main
struct UNCmorfi: App {

    init() {
        ImageResponseSerializer.addAcceptableImageContentTypes(["application/octet-stream"])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
