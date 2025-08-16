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
    
    func saveMultiple(_ records: [ActivityRecord]) throws {
        guard let db else {
            throw DatabaseError.connectionNotAvailable
        }
        
        // バリデーション
        for record in records {
            guard record.hour >= 0 && record.hour <= 23 else {
                throw DatabaseError.invalidHour
            }
            
            guard record.activityPoints >= 0 && record.activityPoints <= 6 else {
                throw DatabaseError.invalidActivityPoints
            }
        }
        
        // トランザクションで一括処理
        try db.transaction {
            for record in records {
                let insert = ActivityRecord.table.insert(or: .replace, record.insertValues)
                try db.run(insert)
            }
        }
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

    func getUnrecordedHourRange(for date: Date, includes hour: Int) throws -> (startHour: Int, endHour: Int)? {
        let sanitizedDate = Calendar.current.startOfDay(for: date)
        let records = try findByDate(sanitizedDate)

        guard !records.contains(where: { $0.hour == hour }) else {
            return nil // hour に記録がある場合 = UnrecordedHourRangeがない
        }

        let startHour = records.reduce(0) { partialResult, record in
            guard record.hour < hour else {
                return partialResult
            }
            if record.hour < partialResult {
                return partialResult
            } else {
                return record.hour + 1
            }
        }
        let endHour = records.reduce(23) { partialResult, record in
            guard record.hour > hour else {
                return partialResult
            }
            if record.hour > partialResult {
                return partialResult
            } else {
                return record.hour - 1
            }
        }

        return (startHour, endHour)
    }
}

enum DatabaseError: Error {
    case connectionNotAvailable
    case invalidHour
    case invalidActivityPoints
    case invalidDate
}
