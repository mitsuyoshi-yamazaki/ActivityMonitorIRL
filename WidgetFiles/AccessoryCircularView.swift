import SwiftUI
import WidgetKit

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
    
    private func createWidgetURL() -> URL? {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return URL(string: "activitymonitor://widget-quickrecord?hour=\(currentHour)")
    }
}

struct AccessoryRectangularView: View {
    let entry: SimpleEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack {
                Image(systemName: "figure.walk")
                    .font(.system(size: 12))
                Text("活動記録")
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
            }
            
            Text("今日: \(entry.activityData.todayTotal)pt")
                .font(.system(size: 14, weight: .bold))
            
            if let currentActivity = entry.activityData.currentHourActivity {
                let currentHour = Calendar.current.component(.hour, from: Date())
                Text("\(currentHour)時: \(currentActivity)pt")
                    .font(.system(size: 11))
                    .opacity(0.8)
            } else {
                let currentHour = Calendar.current.component(.hour, from: Date())
                Text("\(currentHour)時: 未記録")
                    .font(.system(size: 11))
                    .opacity(0.6)
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
        .widgetURL(createWidgetURL())
    }
    
    private func createWidgetURL() -> URL? {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return URL(string: "activitymonitor://widget-quickrecord?hour=\(currentHour)")
    }
}

struct AccessoryInlineView: View {
    let entry: SimpleEntry
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "figure.walk")
                .font(.system(size: 12))
            
            Text("活動: \(entry.activityData.todayTotal)pt")
                .font(.system(size: 12, weight: .medium))
            
            if let currentActivity = entry.activityData.currentHourActivity {
                Text("(\(currentActivity))")
                    .font(.system(size: 12))
                    .opacity(0.7)
            } else {
                Text("(未記録)")
                    .font(.system(size: 12))
                    .opacity(0.5)
            }
        }
        .widgetURL(createWidgetURL())
    }
    
    private func createWidgetURL() -> URL? {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return URL(string: "activitymonitor://widget-quickrecord?hour=\(currentHour)")
    }
}