import SwiftUI
import Foundation

struct DayRecord {
    let date: Date
    let totalPoints: Int
}

class HistorySummaryViewModel: ObservableObject {
    @Published var dayRecords: [DayRecord] = []
    @Published var selectedPeriod: TimePeriod = .week
    
    enum TimePeriod: String, CaseIterable {
        case week = "週"
        case month = "月"
        case year = "年"
    }
    
    var filteredRecords: [DayRecord] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            return dayRecords.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return dayRecords.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return dayRecords.filter { $0.date >= yearAgo }
        }
    }
    
    var averagePoints: Double {
        guard !filteredRecords.isEmpty else { return 0 }
        let total = filteredRecords.reduce(0) { $0 + $1.totalPoints }
        return Double(total) / Double(filteredRecords.count)
    }
}