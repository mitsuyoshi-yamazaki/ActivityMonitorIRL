import Foundation
import SQLite

extension Date: Value {
    public static var declaredDatatype: String {
        return String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ stringValue: String) -> Date {
        return SQLDateFormatter.date(from: stringValue) ?? Date()
    }
    
    public var datatypeValue: String {
        return SQLDateFormatter.string(from: self)
    }
}

let SQLDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()
