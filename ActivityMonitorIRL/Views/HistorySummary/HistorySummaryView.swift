import SwiftUI

struct HistorySummaryView: View {
    var body: some View {
        VStack {
            Text("履歴集計")
                .font(.largeTitle)
                .padding()
            
            Text("過去の活動記録の総量を確認する画面")
                .foregroundColor(.secondary)
                .padding()
            
            Spacer()
        }
        .navigationTitle("履歴集計")
    }
}

#Preview {
    NavigationStack {
        HistorySummaryView()
    }
}