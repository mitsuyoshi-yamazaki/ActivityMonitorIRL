import SwiftUI

struct MainTabView: View {
    let shouldShowQuickRecord: Bool
    let quickRecordHour: Int?
    @State private var selectedTab = 0
    
    init(shouldShowQuickRecord: Bool = false, quickRecordHour: Int? = nil) {
        self.shouldShowQuickRecord = shouldShowQuickRecord
        self.quickRecordHour = quickRecordHour
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DailyActivityView(
                    shouldShowQuickRecord: shouldShowQuickRecord,
                    quickRecordHour: quickRecordHour
                )
            }
            .tabItem {
                Image(systemName: "calendar.day.timeline.leading")
                Text("日別記録")
            }
            .tag(0)
            
            NavigationStack {
                HistorySummaryView()
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("集計")
            }
            .tag(1)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("設定")
            }
            .tag(2)
        }
        .onAppear {
            if shouldShowQuickRecord {
                selectedTab = 0  // DailyActivityViewタブを選択
            }
        }
    }
}

#Preview {
    MainTabView()
}
