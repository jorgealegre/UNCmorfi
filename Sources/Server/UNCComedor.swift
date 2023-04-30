import Foundation
import SharedModels
import SwiftSoup

struct UNCComedor {

    // MARK: URLSession

    private let session = URLSession.shared

    // MARK: API endpoints

    private static let baseDataURL = URL(string: "https://comedor.unc.edu.ar/gv-ds.php")!
    private static let baseMenuURL = URL(string: "https://www.unc.edu.ar/vida-estudiantil/men%C3%BA-de-la-semana")!
    private static let baseServingsURL = URL(string: "https://comedor.unc.edu.ar/gv-ds.php?accion=1&sede=0475")!
    private static let baseImageURL = URL(string: "https://asiruws.unc.edu.ar/foto/")!

    // MARK: Errors

    enum APIError: Error {
        /// General error for non 200 HTTP code responses
        case badResponse

        /// When the response cannot be decoded
        case dataDecodingError

        case menuUnparseable
        case userUnparseable
        case userNotFound
        case servingDateUnparseable
        case servingCountUnparseable
    }

    // MARK: - API

    func getMenu() async throws -> Menu {
        let (data, _): (Data, URLResponse)
        do {
            (data, _) = try await session.data(from: UNCComedor.baseMenuURL)
        } catch {
            // Check what error this is
            throw APIError.badResponse
        }

        guard let dataString = String(data: data, encoding: .utf8) else {
            throw APIError.dataDecodingError
        }

        // Try to parse HTML and find the elements we care about.
        let elements: Elements
        let monthYear: String
        do {
            let doc = try SwiftSoup.parse(dataString)
            elements = try doc.select("div[class='field-item even']")
            monthYear = try elements.select("div[class='tabla_title']").text().components(separatedBy: "-")[1].trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            throw APIError.menuUnparseable
        }

        // Should handle parsing lightly, don't completely know server's behaviour.
        // Prefer to not show anything or parse wrongly than to crash.
        var menu: [Date: [String]] = [:]

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        formatter.locale = Locale(identifier: "es_AR")

        // Try to parse the menu.
        do {
            var lastDay: Date?
            var currentElement = try? elements.select("p u strong").first()?.parent()?.parent()

            while currentElement != nil {
                let element = currentElement!

                if try element.select("p u strong").first() != nil {
                    guard
                        let dayNumber = try? element.text().split(separator: " ").last,
                        let date = formatter.date(from: "\(monthYear) \(dayNumber)")
                    else {
                        throw APIError.menuUnparseable
                    }
                    lastDay = date
                    menu[date] = []
                } else if try element.select("ul").first() != nil {
                    let food: [String] = try element.select("li").array()
                        .compactMap { try? $0.text() }
                        .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

                    guard let lastDay else { continue }
                    menu[lastDay]?.append(contentsOf: food)
                } else if try element.select("br").first() != nil {
                    let food: [String] = try element.outerHtml().split(separator: "<br>").map {
                        try SwiftSoup.parseBodyFragment(String($0)).text()
                    }
                    guard let lastDay else { continue }
                    menu[lastDay]?.append(contentsOf: food)
                }

                currentElement = try? currentElement?.nextElementSibling()
            }
        } catch {
            throw APIError.menuUnparseable
        }

        // For some reason, Kitura encodes a [Date: [String]] dictionary wrong.
        // Using strings as keys instead in the meantime.
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        var uglyMenu: [String: [String]] = [:]
        for (key, value) in menu {
            uglyMenu[dateFormatter.string(from: key)] = value
        }

        return Menu(menu: uglyMenu)
    }

    private func getUser(from code: String) async throws -> User {
        // Prepare the request and its parameters.
        var request = URLRequest(url: UNCComedor.baseDataURL)
        request.httpMethod = "POST"
        request.httpBody = "accion=4&codigo=\(code)".data(using: .utf8)

        let (data, _): (Data, URLResponse)
        do {
            (data, _) = try await session.data(for: request)
        } catch {
            throw APIError.badResponse
        }

        guard let dataString = String(data: data, encoding: .utf8) else {
            throw APIError.dataDecodingError
        }

        guard !dataString.contains("rows: []") else { throw APIError.userNotFound }

        // Parse the data.
        let preffix = "rows: [{c: ["
        let suffix = "]}]}});"

        guard
            let preffixIndex = dataString.range(of: preffix)?.upperBound,
            let suffixIndex = dataString.range(of: suffix)?.lowerBound
        else {
            throw APIError.userUnparseable
        }
        let components = dataString[preffixIndex..<suffixIndex].components(separatedBy: "},{")

        let firstName: String?
        let _16 = components[16]
        if _16 == "v: null" {
            firstName = nil
        } else {
            firstName = String(_16[_16.index(_16.startIndex, offsetBy: 4)..._16.index(_16.startIndex, offsetBy: _16.count - 2)])
        }

        let lastName: String?
        let _17 = components[17]
        if _17 == "v: null" {
            lastName = nil
        } else {
            lastName = String(_17[_17.index(_17.startIndex, offsetBy: 4)..._17.index(_17.startIndex, offsetBy: _17.count - 2)])
        }

        let balance: Int?
        let _5 = components[5]
        if _5 == "v: null" {
            balance = nil
        } else {
            balance = Int(String(_5[_5.index(_5.startIndex, offsetBy: 3)..._5.index(_5.startIndex, offsetBy: _5.count - 1)]))
        }

        let imageURL: URL?
        let _24 = components[24]
        if _24 == "v: null" {
            imageURL = nil
        } else {
            let temp = String(_24[_24.index(_24.startIndex, offsetBy: 4)..._24.index(_24.startIndex, offsetBy: _24.count - 2)])
            imageURL = UNCComedor.baseImageURL.appendingPathComponent(temp)
        }

        var _8 = components[8]
        _8 = String(_8[_8.index(_8.startIndex, offsetBy: 4)..._8.index(_8.endIndex, offsetBy: -2)])

        var _4 = components[4]
        _4 = String(_4[_4.index(_4.startIndex, offsetBy: 12)..._4.index(_4.endIndex, offsetBy: -2)])
        _4 = _4.components(separatedBy: ", ").joined(separator: "-") + "T00:00:00Z"

        let name = "\(firstName ?? "") \(lastName ?? "")".trimmingCharacters(in: .whitespacesAndNewlines)
        let type = _8

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.formatOptions = [.withInternetDateTime]
        let expirationDate = dateFormatter.date(from: _4)!

        let user = User(
            balance: balance ?? 0,
            expirationDate: expirationDate,
            id: code,
            imageURL: imageURL,
            name: name,
            type: type
        )

        return user
    }

    func getUsers(from codes: [String]) async throws -> [User] {
        guard !codes.isEmpty else { return [] }

        // API only returns one user at a time. Use a task group to execute many requests in
        // parallel and wait for all to finish.

        return try await withThrowingTaskGroup(of: User.self) { group in
            codes.forEach { code in
                group.addTask(operation: { try await getUser(from: code) })
            }

            var users: [User] = []
            for try await user in group {
                users.append(user)
            }

            return users
        }
    }

    func getServings() async throws -> Servings {
        let (data, _): (Data, URLResponse)
        do {
            (data, _) = try await session.data(from: UNCComedor.baseServingsURL)
        } catch {
            throw APIError.badResponse
        }

        guard let dataString = String(data: data, encoding: .utf8) else {
            throw APIError.dataDecodingError
        }


        // Server response is weird Javascript function application with data as function's parameter.
        // Data is not a JSON string but a Javascript object, not to be confused with one another.

        // Attempt to parse string into something useful.
        guard
            let start = dataString.range(of: "(")?.upperBound,
            let end = dataString.range(of: ")")?.lowerBound
        else {
            throw APIError.servingCountUnparseable
        }
        var jsonString = String(dataString[start..<end])

        jsonString = jsonString
        // Add quotes to keys.
            .replacingOccurrences(of: "(\\w*[A-Za-z]\\w*)\\s*:",
                                  with: "\"$1\":",
                                  options: .regularExpression,
                                  range: jsonString.startIndex..<jsonString.endIndex)
        // Replace single quotes with double quotes.
            .replacingOccurrences(of: "'", with: "\"")

        // Parse fixed string.
        guard let jsonData = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                  throw APIError.servingCountUnparseable
              }

        // Transform complicated JSON structure into simple [Date: Int] dictionary.
        guard let table = json["table"] as? [String: [[String: Any]]],
              let rows = table["rows"] else {
                  throw APIError.servingCountUnparseable
              }

        let result = rows.reduce([Date: Int]()) { (result, row) -> [Date: Int] in
            // 'result' parameter is constant, can't be changed.
            var result = result

            guard let row = row["c"] as? [[String: Any]] else {
                return result
            }

            // The server only gave us a time in timezone GMT-3 (e.g. 12:09:00)
            // We need to add the current date and timezone data. (e.g. 2017-09-10 15:09:00 +0000)
            // Start off by getting the current date.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'"

            let todaysDate = dateFormatter.string(from: Date())

            // Join today's date, the time from the row and the timezone into one string in ISO format.
            guard let time = row[0]["v"] as? String else {
                return result
            }
            let dateString = "\(todaysDate)\(time)-0300"

            // Add time and timezone support to the parser.
            let timeFormat = "HH:mm:ssZ"
            dateFormatter.dateFormat = dateFormatter.dateFormat + timeFormat

            // Get a Date object from the resulting string.
            guard let date = dateFormatter.date(from: dateString) else {
                return result
            }

            // Get food count from row.
            guard let count = row[1]["v"] as? Int else {
                return result
            }

            // Add data to the dictionary.
            result[date] = count

            return result
        }

        // TODO this is a workaround of an error with Kitura not encoding Date keys properly.
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        var servings: [String: Int] = [:]
        for (key, value) in result {
            servings[dateFormatter.string(from: key)] = value
        }
        return Servings(servings: servings)
    }
}
