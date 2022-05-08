//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import Combine
import class AlamofireImage.ImageDownloader

struct RemoteImage: View {

    // MARK: - Properties

    @State private var image: Image? = nil

    @State private var isLoading = true

    private let imagePublisher: AnyPublisher<Image?, Never>

    // MARK: - Initializers

    init(url: URL?) {
        self.imagePublisher = ImageDownloader.default
            .image(for: url)
            .map { $0.flatMap(Image.init) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Views

    var body: some View {
        SubscriptionView(content: content, publisher: imagePublisher) { image in
            self.image = image
            self.isLoading = false
        }
    }

    private var content: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }
            image.aspectRatio(contentMode: .fill)
        }
    }
}

struct LoadingImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: URL(string: "https://github.com/roberthein/TinyConstraints/blob/master/Art/header.png"))
    }
}
