import Foundation
import SQLite

struct WidgetActivityData {
    struct HourlyActivity {
        let hour: Int
        let point: Int?
    }

    let todayTotal: Int?
    let currentHourActivity: HourlyActivity
}

class WidgetActivityRepository {
    func getTodayActivityData() -> WidgetActivityData {
        let currentHour = Calendar.current.component(.hour, from: Date())
        guard let summary = UserDefaults.appGroup.todaySummary else {
            return .init(todayTotal: nil, currentHourActivity: .init(hour: currentHour, point: nil))
        }

        let totalPoints = summary.reduce(0, { $0 + $1.value })
        let currentHourActivityPoint = summary[currentHour]

        return .init(
            todayTotal: totalPoints,
            currentHourActivity: .init(hour: currentHour, point: currentHourActivityPoint),
        )
    }
}
