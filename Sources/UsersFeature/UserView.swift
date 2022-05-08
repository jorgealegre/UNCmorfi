import SharedModels
import SwiftUI

struct UserView: View {
    let user: User

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "ARS"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    var body: some View {
        HStack {
            AsyncImage(url: user.imageURL) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if let _ = phase.error {
                    EmptyView()
                } else {
                    ProgressView()
                }
            }
            .clipShape(Circle())
            .frame(width: 64, height: 64)
            .overlay {
                Circle()
                    .stroke(Color.primary, lineWidth: 1)
            }

            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.title)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                Text("Expires: \(user.expirationDate, formatter: UserView.dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    Text(user.id)
                        .font(.system(size: 20).bold().monospaced())

                    Spacer()

                    Text("\(UserView.numberFormatter.string(from: user.balance as NSNumber)!)")
                        .font(.title2)
                        .monospacedDigit()
                        .fontWeight(.bold)
                }
            }

            Spacer()
        }
        .padding(.vertical)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserView(user: .mock1)

            UserView(user: .mock2)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 400, height: 150))
    }
}
