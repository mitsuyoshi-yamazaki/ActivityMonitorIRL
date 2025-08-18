import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                DailyActivityView()
            }
            .tabItem {
                Image(systemName: "calendar.day.timeline.leading")
                Text("日別記録")
            }
            
            NavigationStack {
                HistorySummaryView()
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("集計")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("設定")
            }
        }
    }
}

#Preview {
    MainTabView()
}
