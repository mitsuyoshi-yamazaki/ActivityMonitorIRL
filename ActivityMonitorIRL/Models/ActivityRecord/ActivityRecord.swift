import Foundation
import SQLite

struct ActivityRecord: Codable {
    let date: Date
    let hour: Int
    let activityPoints: Int
    let activity: String?
    
}

extension ActivityRecord {
    static let table = Table("activity_records")
    static let dateColumn = SQLite.Expression<Date>("date")
    static let hourColumn = SQLite.Expression<Int>("hour")
    static let activityPointsColumn = SQLite.Expression<Int>("activity_points")
    static let activityColumn = SQLite.Expression<String?>("activity")
    
    static func createTable(_ db: Connection) throws {
        try db.run(table.create(ifNotExists: true) { tableBuilder in
            tableBuilder.column(dateColumn)
            tableBuilder.column(hourColumn)
            tableBuilder.column(activityPointsColumn)
            tableBuilder.column(activityColumn)
            tableBuilder.primaryKey(dateColumn, hourColumn)
        })
    }
    
    init(row: Row) {
        self.date = row[Self.dateColumn]
        self.hour = row[Self.hourColumn]
        self.activityPoints = row[Self.activityPointsColumn]
        self.activity = row[Self.activityColumn]
    }
    
    var insertValues: [Setter] {
        return [
            Self.dateColumn <- date,
            Self.hourColumn <- hour,
            Self.activityPointsColumn <- activityPoints,
            Self.activityColumn <- activity
        ]
    }
}
