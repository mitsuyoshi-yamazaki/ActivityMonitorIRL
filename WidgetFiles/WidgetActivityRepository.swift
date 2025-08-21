import Foundation
import SQLite

struct WidgetActivityData {
    let todayTotal: Int
    let currentHourActivity: Int?
    let lastUpdateTime: Date
}

class WidgetActivityRepository {
    private let sharedDatabaseManager = SharedDatabaseManager.shared
    
    func getTodayActivityData() -> WidgetActivityData {
        let summary = sharedDatabaseManager.getTodayActivitySummary()
        
        return WidgetActivityData(
            todayTotal: summary.totalPoints,
            currentHourActivity: summary.currentHourActivity,
            lastUpdateTime: Date()
        )
    }
    
    func getCurrentHourStatus() -> String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let summary = sharedDatabaseManager.getTodayActivitySummary()
        
        if let activity = summary.currentHourActivity {
            return "\(activity)pt"
        } else {
            return "未記録"
        }
    }
    
    func getTodayProgress() -> Double {
        let summary = sharedDatabaseManager.getTodayActivitySummary()
        // 1日の最大ポイントを144pt (24時間 × 6pt)として進捗を計算
        let maxDailyPoints = 144.0
        return min(Double(summary.totalPoints) / maxDailyPoints, 1.0)
    }
    
    func getDisplaySummary() -> String {
        let summary = sharedDatabaseManager.getTodayActivitySummary()
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        if let currentActivity = summary.currentHourActivity {
            return "\(summary.totalPoints)pt (\(currentHour)時: \(currentActivity)pt)"
        } else {
            return "\(summary.totalPoints)pt (\(currentHour)時: 未記録)"
        }
    }
}