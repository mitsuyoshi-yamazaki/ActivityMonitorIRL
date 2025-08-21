import Foundation
import SQLite

class SharedDatabaseManager {
    static let shared = SharedDatabaseManager()
    private var db: Connection?
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.mitsuyoshi.activitymonitorirl"
        ) else {
            fallbackToLocalDatabase()
            return
        }
        
        let sharedDbPath = containerURL.appendingPathComponent("SharedActivityMonitor.sqlite")
        
        do {
            db = try Connection(sharedDbPath.path)
            createTablesIfNeeded()
            print("Shared database initialized at: \(sharedDbPath.path)")
        } catch {
            print("Failed to create shared database: \(error)")
            fallbackToLocalDatabase()
        }
    }
    
    private func fallbackToLocalDatabase() {
        // App Groups設定前の場合、従来のローカルデータベースを使用
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, 
                                                           in: .userDomainMask).first else {
            print("Failed to get documents directory for fallback")
            return
        }
        
        do {
            let dbPath = documentsPath.appendingPathComponent("ActivityMonitor.sqlite")
            db = try Connection(dbPath.path)
            createTablesIfNeeded()
            print("Fallback to local database at: \(dbPath.path)")
        } catch {
            print("Failed to create fallback database: \(error)")
        }
    }
    
    private func createTablesIfNeeded() {
        guard let db else { return }
        
        do {
            try db.run(ActivityRecord.table.create(ifNotExists: true) { table in
                table.column(ActivityRecord.dateColumn, primaryKey: true)
                table.column(ActivityRecord.hourColumn, primaryKey: true)
                table.column(ActivityRecord.activityPointsColumn)
                table.column(ActivityRecord.activityColumn)
            })
        } catch {
            print("Failed to create tables: \(error)")
        }
    }
    
    func getDatabase() -> Connection? {
        return db
    }
    
    // Widget用の軽量データ取得メソッド
    func getTodayActivitySummary() -> (totalPoints: Int, currentHourActivity: Int?) {
        guard let db else { return (0, nil) }
        
        let today = Calendar.current.startOfDay(for: Date())
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        do {
            // 今日の総ポイント取得
            let totalPoints = try db.scalar(
                ActivityRecord.table
                    .filter(ActivityRecord.dateColumn == today)
                    .select(ActivityRecord.activityPointsColumn.sum)
            ) ?? 0
            
            // 現在時刻の活動ポイント取得
            let currentHourActivity = try db.pluck(
                ActivityRecord.table
                    .filter(ActivityRecord.dateColumn == today && ActivityRecord.hourColumn == currentHour)
            )?[ActivityRecord.activityPointsColumn]
            
            return (Int(totalPoints), currentHourActivity)
        } catch {
            print("Failed to get today's activity summary: \(error)")
            return (0, nil)
        }
    }
    
    // 既存のデータベースから共有データベースへの移行
    func migrateToSharedDatabase() {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.mitsuyoshi.activitymonitorirl"
        ) else { return }
        
        let sharedDbPath = containerURL.appendingPathComponent("SharedActivityMonitor.sqlite")
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, 
                                                           in: .userDomainMask).first else {
            print("Failed to get documents directory for migration")
            return
        }
        let localDbPath = documentsPath.appendingPathComponent("ActivityMonitor.sqlite")
        
        // ローカルDBが存在し、共有DBが存在しない場合のみ移行
        if FileManager.default.fileExists(atPath: localDbPath.path) &&
           !FileManager.default.fileExists(atPath: sharedDbPath.path) {
            
            do {
                try FileManager.default.copyItem(at: localDbPath, to: sharedDbPath)
                print("Successfully migrated database to shared location")
            } catch {
                print("Failed to migrate database: \(error)")
            }
        }
    }
}
