import SwiftUI
import Foundation

class DailyActivityViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var hourlyRecords: [Int: ActivityRecord] = [:]
    @Published var isLoading = false
    @Published var isShowingTextInput = false
    @Published var selectedHour: Int = 0
    @Published var activityText: String = ""
    
    private let repository = ActivityRepository()
    private let calendar = Calendar.current
    
    var totalPoints: Int {
        hourlyRecords.values.reduce(0) { $0 + $1.activityPoints }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP") // 日本語の曜日を出す
        formatter.dateFormat = "yyyy/MM/dd (E)"
        return formatter
    }()

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

    func getTitle() -> String {
        let date = dateFormatter.string(from: selectedDate)
        return "\(date) \(totalPoints)pt"
    }

    func getDisplayText(for hour: Int) -> String {
        if let record = hourlyRecords[hour] {
            return "\(record.activityPoints)pt"
        } else {
            return "-"
        }
    }

    func getActivity(for hour: Int) -> String? {
        if let record = hourlyRecords[hour] {
            return record.activity
        } else {
            return nil
        }
    }

    func updatePoints(for hour: Int, points: Int) {
        guard hour >= 0 && hour < 24 && points >= 0 && points <= 6 else { return }
        
        let targetDate = calendar.startOfDay(for: selectedDate)
        let record = ActivityRecord(date: targetDate, hour: hour, activityPoints: points, activity: nil)
        
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
            return ActivityRecord(date: targetDate, hour: hour, activityPoints: points, activity: nil)
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
    
    func showTextInput(for hour: Int) {
        selectedHour = hour
        if let record = hourlyRecords[hour] {
            activityText = record.activity ?? ""
        } else {
            activityText = ""
        }
        isShowingTextInput = true
    }
    
    func hideTextInput() {
        isShowingTextInput = false
        activityText = ""
        selectedHour = 0
    }
    
    func updateActivity(for hour: Int, activity: String?) {
        guard hour >= 0 && hour < 24 else { return }
        guard let existingRecord = hourlyRecords[hour] else { return }
        
        let targetDate = calendar.startOfDay(for: selectedDate)
        let updatedRecord = ActivityRecord(
            date: targetDate,
            hour: hour,
            activityPoints: existingRecord.activityPoints,
            activity: activity?.isEmpty == true ? nil : activity
        )
        
        do {
            try repository.save(updatedRecord)
            hourlyRecords[hour] = updatedRecord
            hideTextInput()
        } catch {
            print("Failed to update activity: \(error)")
        }
    }
}
