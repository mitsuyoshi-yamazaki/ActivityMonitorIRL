import SwiftUI
import Foundation

class DailyActivityViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var hourlyPoints: [Int] = Array(repeating: 0, count: 24)
    
    var totalPoints: Int {
        hourlyPoints.reduce(0, +)
    }
    
    func updatePoints(for hour: Int, points: Int) {
        guard hour >= 0 && hour < 24 && points >= 0 && points <= 6 else { return }
        hourlyPoints[hour] = points
    }
}