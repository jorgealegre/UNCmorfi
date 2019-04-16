//
//  Date+DateFormatter.swift
//  UNCmorfi
//
//  Created by Igor Andruskiewitsch on 16/04/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

// DATE FORMAT EXTENSIONS
enum DateFormat: String {
    case snakeFormat = "yyyy-dd-MM"
    case weekDay = "EEEE d"
    case simpleDateFormat = "MM-dd HH:mm"
    case GMT3 = "HH:mm:ssZ"
    case ISODate = "yyyy-MM-dd'T'"
    case ISO = "yyyy-MM-dd'T'HH:mm:ssZ"
}

extension DateFormatter {
    convenience init(format: DateFormat) {
        self.init()
        self.dateFormat = format.rawValue
    }
}

extension Date {
    func string(with format: DateFormat) -> String {
        let formatter = DateFormatter(format: format)
        return formatter.string(from: self)
    }
    
    init?(from string: String, format: DateFormat) {
        let formatter = DateFormatter(format: format)
        guard let date = formatter.date(from: string) else { return nil }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}

extension Date {
    
    static func completeISO(from timeString: String) throws -> Date {
        // The server only gave us a time in timezone GMT-3 (e.g. 12:09:00)
        // We need to add the current date and timezone data. (e.g. 2017-09-10 15:09:00 +0000)
        // Start off by getting the current date.
        let todaysDate = Date().string(with: .ISODate)
        
        // Join today's date, the time and the timezone into one string in ISO format.
        let timestamp = "\(todaysDate)\(timeString)-0300"
        
        guard let date = Date(from: timestamp, format: .ISO) else {
            throw UNCComedor.UNCComedorError.servingDateUnparseable
        }
        
        return date
    }
    
}
