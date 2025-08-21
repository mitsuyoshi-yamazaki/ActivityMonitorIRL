import SwiftUI
import WidgetKit

private func createWidgetURL() -> URL? {
    let currentHour = Calendar.current.component(.hour, from: Date())
    return URL(string: "activitymonitor://widget-quickrecord?hour=\(currentHour)")
}

struct AccessoryCircularView: View {
    let entry: SimpleEntry
    
    var body: some View {
        let title: String
        if let totalPoints = entry.activityData.todayTotal {
            title = "\(totalPoints)pt"
        } else {
            title = "- pt"
        }

        let activity = entry.activityData.currentHourActivity
        let description: String
        if let currentActivityPoint = activity.point {
            description = "\(activity.hour)時: \(currentActivityPoint)pt"
        } else {
            description = "\(activity.hour)時: - pt"
        }

        return ZStack {
            AccessoryWidgetBackground()
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.6)
                
                Text(description)
                    .font(.system(size: 10, weight: .medium))
                    .opacity(0.8)
            }
        }
        .widgetURL(createWidgetURL())
    }
}

struct AccessoryCircularViewPreview: PreviewProvider {
    static var previews: some View {
        AccessoryCircularView(entry: .init(date: Date(), activityData: .init(todayTotal: 32, currentHourActivity: .init(hour: 15, point: 3))))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .containerBackground(.fill.tertiary, for: .widget)
    }
}
