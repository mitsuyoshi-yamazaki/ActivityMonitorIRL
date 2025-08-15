import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    
    private init() {
        do {
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Failed to get documents directory")
                return
            }
            let dbPath = documentsPath.appendingPathComponent("ActivityMonitor.sqlite").path
            db = try Connection(dbPath)
            createTables()
        } catch {
            print("Database initialization failed: \(error)")
        }
    }
    
    func getDatabase() -> Connection? {
        return db
    }
    
    private func createTables() {
        guard let db else { return }
        
        do {
            try ActivityRecord.createTable(db)
        } catch {
            print("Table creation failed: \(error)")
        }
    }
}