import SharedModels
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        "Hello, world!"
    }

    app.get("users") { req -> [User] in
        let userCodes: [String]? = req.query["codes"]
        guard let userCodes = userCodes else { return [] }

        return try await UNCComedor().getUsers(from: userCodes)
    }

    app.get("menu") { req async throws -> Menu in
        try await UNCComedor().getMenu()
    }

    app.get("servings") { req async throws -> Servings in
        try await UNCComedor().getServings()
    }
}

extension Menu: Content { }
extension User: Content { }
extension Servings: Content { }
