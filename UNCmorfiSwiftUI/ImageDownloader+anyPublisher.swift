//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import Combine
import AlamofireImage

extension ImageDownloader {
    func image(for url: URL?) -> AnyPublisher<UIImage?, Never> {
        guard let url = url else {
            return Just(nil).eraseToAnyPublisher()
        }

        return Future { promise in
            let urlRequest = URLRequest(url: url)
            self.download(urlRequest) { response in
                promise(.success(response.result.value))
            }
        }
        .eraseToAnyPublisher()
    }
}
