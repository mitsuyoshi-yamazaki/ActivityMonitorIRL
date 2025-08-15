import Foundation

class TestDatabaseConnection {
    static func test() {
        let repo = ActivityRepository()
        let testRecord = ActivityRecord(
            date: Date(),
            hour: 12,
            activityPoints: 3
        )
        
        do {
            try repo.save(testRecord)
            let records = try repo.findByDate(Date())
            print("Database test successful. Found \(records.count) records.")
        } catch {
            print("Database test failed: \(error)")
        }
    }
}