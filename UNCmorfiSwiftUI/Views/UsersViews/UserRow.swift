//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import UNCmorfiKit

//import Combine
//import AlamofireImage
//extension ImageDownloader {
//    func image(for url: URL) -> AnyPublisher<UIImage?, Never> {
//        return Future { promise in
//            let urlRequest = URLRequest(url: url)
//            self.download(urlRequest) { response in
//                promise(.success(response.result.value))
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}
//
//struct RemoteImage: View {
//    let url: URL
//
//    @State private var image: UIImage? = nil
//
//    init(url: URL) {
//        ImageDownloader.default.image(for: url).handleEvents(receiveSubscription: { subscription in
//            subscription.
//        })
//    }
//
//    var body: some View {
//        Group {
//            if image != nil {
//                Image(uiImage: image!)
//            } else {
//                Image(systemName: "person.crop.circle")
//            }
//        }
//    }
//}

struct BalanceRow: View {
    let balance: User

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
            VStack {
                Text(balance.name)
                Text(balance.code)
            }
            Spacer()
            Text("$\(balance.balance)")
        }
    }
}

struct BalanceRow_Previews: PreviewProvider {
    static var previews: some View {
        BalanceRow(balance: users[0])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
