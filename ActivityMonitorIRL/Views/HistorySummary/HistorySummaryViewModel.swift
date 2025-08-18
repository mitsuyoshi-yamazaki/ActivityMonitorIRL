import SwiftUI
import Foundation

class HistorySummaryViewModel: ObservableObject {
    @Published var dailySummaries: [DailySummary] = []
    @Published var isLoading = false
    
    private let repository = ActivityRepository()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd (E)"
        return formatter
    }()
    
    init() {
        loadDailySummaries()
    }
    
    func loadDailySummaries() {
        isLoading = true
        do {
            dailySummaries = (try repository.getDailySummaries()).sorted(by: { lhs, rhs in
                return lhs.date > rhs.date
            })
        } catch {
            print("Failed to load daily summaries: \(error)")
            dailySummaries = []
        }
        isLoading = false
    }
    
    func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func refresh() {
        loadDailySummaries()
    }
}
