import Foundation

public struct User: Codable, Identifiable, Equatable {
    public let balance: Int
    public let expirationDate: Date
    public let id: String
    public let imageURL: URL?
    public let name: String
    public let type: String

    public init(
        balance: Int = 0,
        expirationDate: Date,
        id: String,
        imageURL: URL? = nil,
        name: String,
        type: String
    ) {
        self.balance = balance
        self.expirationDate = expirationDate
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.type = type
    }
}

extension User {
    public static let mock1 = User(
        balance: 132,
        expirationDate: Date().addingTimeInterval(4 * 24 * 60 * 60),
        id: "04756A29333C62D",
        imageURL: URL(string: "https://asiruws.unc.edu.ar/foto/fbb431f8-5e63-48f8-afac-bdf1de79966f")!,
        name: "Jorge Facundo Alegre",
        type: "Estudiante de Grado"
    )

    public static let mock2 = User(
        balance: 68,
        expirationDate: Date().addingTimeInterval(7 * 24 * 60 * 60),
        id: "04753BF1041EAD4",
        imageURL: URL(string: "https://asiruws.unc.edu.ar/foto/c0df77b9-a3c7-4a42-8169-aa95bc626eec")!,
        name: "Emanuel Meriles",
        type: "Docente"
    )
}
