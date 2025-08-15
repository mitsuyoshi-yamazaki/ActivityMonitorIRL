import Foundation
import SQLite

class ActivityRepository {
    private let db: Connection?
    
    init() {
        self.db = DatabaseManager.shared.getDatabase()
    }
    
    func save(_ record: ActivityRecord) throws {
        guard let db else {
            throw DatabaseError.connectionNotAvailable
        }
        
        guard record.hour >= 0 && record.hour <= 23 else {
            throw DatabaseError.invalidHour
        }
        
        guard record.activityPoints >= 0 && record.activityPoints <= 6 else {
            throw DatabaseError.invalidActivityPoints
        }
        
        let insert = ActivityRecord.table.insert(or: .replace, record.insertValues)
        try db.run(insert)
    }
    
    func findByDate(_ date: Date) throws -> [ActivityRecord] {
        guard let db else {
            throw DatabaseError.connectionNotAvailable
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            throw DatabaseError.invalidDate
        }
        
        let query = ActivityRecord.table
            .filter(ActivityRecord.dateColumn >= startOfDay && ActivityRecord.dateColumn < endOfDay)
            .order(ActivityRecord.hourColumn)
        
        return try db.prepare(query).map { ActivityRecord(row: $0) }
    }
    
    func findByDateAndHour(_ date: Date, hour: Int) throws -> ActivityRecord? {
        guard let db else {
            throw DatabaseError.connectionNotAvailable
        }
        
        guard hour >= 0 && hour <= 23 else {
            throw DatabaseError.invalidHour
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        let query = ActivityRecord.table
            .filter(ActivityRecord.dateColumn == startOfDay && ActivityRecord.hourColumn == hour)
        
        if let row = try db.pluck(query) {
            return ActivityRecord(row: row)
        }
        return nil
    }
    
    func delete(_ record: ActivityRecord) throws {
        guard let db else {
            throw DatabaseError.connectionNotAvailable
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: record.date)
        
        let query = ActivityRecord.table
            .filter(ActivityRecord.dateColumn == startOfDay && ActivityRecord.hourColumn == record.hour)
        
        try db.run(query.delete())
    }
    
    func findAll() throws -> [ActivityRecord] {
        guard let db else {
            throw DatabaseError.connectionNotAvailable
        }
        
        let query = ActivityRecord.table
            .order(ActivityRecord.dateColumn.desc, ActivityRecord.hourColumn)
        
        return try db.prepare(query).map { ActivityRecord(row: $0) }
    }
}

enum DatabaseError: Error {
    case connectionNotAvailable
    case invalidHour
    case invalidActivityPoints
    case invalidDate
}