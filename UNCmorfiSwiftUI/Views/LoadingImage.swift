//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import Combine
import class AlamofireImage.ImageDownloader

struct RemoteImage: View {

    @State private var image: Image? = nil

    @State private var isLoading = true

    private let imagePublisher: AnyPublisher<Image?, Never>

    init(url: URL?) {
        self.imagePublisher = ImageDownloader.default
            .image(for: url)
            .map { $0.flatMap(Image.init) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var body: some View {
        SubscriptionView(content: content, publisher: imagePublisher) { image in
            self.image = image
            self.isLoading = false
        }
    }

    private var content: some View {
        ZStack {
            ActivityIndicator(isAnimating: $isLoading, style: .medium)
            image.aspectRatio(contentMode: .fill)
        }
    }
}
