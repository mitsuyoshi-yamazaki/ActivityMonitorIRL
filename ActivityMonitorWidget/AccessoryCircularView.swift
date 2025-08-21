import SwiftUI
import WidgetKit

private func createWidgetURL() -> URL? {
    let currentHour = Calendar.current.component(.hour, from: Date())
    return URL(string: "activitymonitor://widget-quickrecord?hour=\(currentHour)")
}

struct AccessoryCircularView: View {
    let entry: SimpleEntry
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            VStack(spacing: 2) {
                // 今日の総ポイント
                Text("\(entry.activityData.todayTotal)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.6)
                
                Text("pt")
                    .font(.system(size: 10, weight: .medium))
                    .opacity(0.8)
            }
        }
        .widgetURL(createWidgetURL())
    }
}
