import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    private let currentSchemaVersion = 2
    
    private init() {
        do {
            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Failed to get documents directory")
                return
            }
            let dbPath = documentsPath.appendingPathComponent("ActivityMonitor.sqlite").path
            db = try Connection(dbPath)
            try performMigrations()
            createTables()
            
            // App Groups対応の場合、データを共有データベースに移行
            SharedDatabaseManager.shared.migrateToSharedDatabase()
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
    
    private func performMigrations() throws {
        guard let db else { return }
        guard let userVersion = try db.scalar("PRAGMA user_version") as? Int64 else { return }
        let currentVersion = Int64(currentSchemaVersion)
        
        if userVersion < currentVersion {
            print("Migrating database from version \(userVersion) to \(currentVersion)")
            
            for version in (userVersion + 1)...currentVersion {
                try migrateToVersion(Int(version))
            }
            
            try db.run("PRAGMA user_version = \(currentVersion)")
        }
    }
    
    private func migrateToVersion(_ version: Int) throws {
        guard let db else { return }
        
        switch version {
        case 2:
            try migrateToVersion2()
        default:
            print("Unknown migration version: \(version)")
        }
    }
    
    private func migrateToVersion2() throws {
        guard let db else { return }
        
        let alterQuery = "ALTER TABLE activity_records ADD COLUMN activity TEXT DEFAULT NULL"
        try db.run(alterQuery)
        print("Migration to version 2 completed: Added activity column")
    }
}
