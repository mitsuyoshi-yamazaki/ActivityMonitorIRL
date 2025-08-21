import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), activityData: WidgetActivityData(
            todayTotal: 24,
            currentHourActivity: 3,
            lastUpdateTime: Date()
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let repository = WidgetActivityRepository()
        let entry = SimpleEntry(date: Date(), activityData: repository.getTodayActivityData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let repository = WidgetActivityRepository()
        let currentDate = Date()
        let activityData = repository.getTodayActivityData()
        
        // 現在のエントリーを作成
        let entry = SimpleEntry(date: currentDate, activityData: activityData)
        
        // 次回更新時刻を設定（15分後）
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let activityData: WidgetActivityData
}

struct ActivityMonitorWidgetEntryView: View {
    let entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            AccessoryCircularView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularView(entry: entry)
        case .accessoryInline:
            AccessoryInlineView(entry: entry)
        default:
            Text("未対応")
        }
    }
}

struct ActivityMonitorWidget: Widget {
    let kind: String = "ActivityMonitorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ActivityMonitorWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("活動記録")
        .description("今日の活動記録を表示し、素早く記録できます。")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}