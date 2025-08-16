import SwiftUI
import Foundation

class DailyActivityViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var hourlyRecords: [Int: ActivityRecord] = [:]
    @Published var isLoading = false
    
    private let repository = ActivityRepository()
    private let calendar = Calendar.current
    
    var totalPoints: Int {
        hourlyRecords.values.reduce(0) { $0 + $1.activityPoints }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
    
    init() {
        loadActivityRecords(for: selectedDate)
    }
    
    func loadActivityRecords(for date: Date) {
        isLoading = true
        do {
            let records = try repository.findByDate(date)
            hourlyRecords = Dictionary(uniqueKeysWithValues: records.map { ($0.hour, $0) })
        } catch {
            print("Failed to load activity records: \(error)")
            hourlyRecords = [:]
        }
        isLoading = false
    }
    
    func getDisplayText(for hour: Int) -> String {
        if let record = hourlyRecords[hour] {
            return "\(record.activityPoints)"
        } else {
            return "-"
        }
    }
    
    func updatePoints(for hour: Int, points: Int) {
        guard hour >= 0 && hour < 24 && points >= 0 && points <= 6 else { return }
        
        let targetDate = calendar.startOfDay(for: selectedDate)
        let record = ActivityRecord(date: targetDate, hour: hour, activityPoints: points)
        
        do {
            try repository.save(record)
            hourlyRecords[hour] = record
        } catch {
            print("Failed to save activity record: \(error)")
        }
    }
    
    func updatePointsForMultipleHours(hours: [Int], points: Int) {
        guard points >= 0 && points <= 6 else { return }
        
        let targetDate = calendar.startOfDay(for: selectedDate)
        let records = hours.compactMap { hour -> ActivityRecord? in
            guard hour >= 0 && hour < 24 else { return nil }
            return ActivityRecord(date: targetDate, hour: hour, activityPoints: points)
        }
        
        do {
            try repository.saveMultiple(records)
            // UI更新
            for record in records {
                hourlyRecords[record.hour] = record
            }
        } catch {
            print("Failed to save multiple activity records: \(error)")
        }
    }
    
    func changeDate(to date: Date) {
        selectedDate = date
        loadActivityRecords(for: date)
    }
}
