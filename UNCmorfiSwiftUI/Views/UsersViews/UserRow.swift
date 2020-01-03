//
// Copyright © 2019 George Alegre. All rights reserved.
//

import SwiftUI
import UNCmorfiKit
import UNCmorfiUI

struct UserRow: View {
    let user: User

    private var formattedBalance: String {
        NumberFormatter.balanceFormatter.string(from: user.balance as NSNumber)!
    }

    var body: some View {
        HStack(spacing: 10) {
            RemoteImage(url: user.imageURL)
                .frame(width: 50, height: 50)
                .cornerRadius(25)

            VStack(alignment: .leading, spacing: 5) {
                Text(user.name)
                    .font(.headline)

                Text(user.code)
                    .font(Font.body.monospacedDigit())
            }

            Spacer()

            VStack {
                Spacer()
                Text(formattedBalance)
                    .font(Font.headline.monospacedDigit())
            }
        }
        .padding(10)
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: MockUserStore.shared.users[0])
            .previewLayout(.fixed(width: 400, height: 70))
    }
}
