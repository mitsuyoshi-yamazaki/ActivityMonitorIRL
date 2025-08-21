import Foundation

struct DailySummary {
    let date: Date
    let totalActivityPoints: Int
    
    init(date: Date, totalActivityPoints: Int) {
        self.date = Calendar.current.startOfDay(for: date)
        self.totalActivityPoints = totalActivityPoints
    }
}

extension DailySummary: Identifiable {
    var id: Date { date }
}

extension DailySummary: Equatable {
    static func == (lhs: DailySummary, rhs: DailySummary) -> Bool {
        return lhs.date == rhs.date && lhs.totalActivityPoints == rhs.totalActivityPoints
    }
}
