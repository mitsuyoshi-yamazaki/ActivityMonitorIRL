import SwiftUI

struct DailyActivityView: View {
    var body: some View {
        VStack {
            Text("日別活動記録")
                .font(.largeTitle)
                .padding()
            
            Text("1日の活動量を記録・編集する画面")
                .foregroundColor(.secondary)
                .padding()
            
            Spacer()
        }
        .navigationTitle("日別記録")
    }
}

#Preview {
    NavigationStack {
        DailyActivityView()
    }
}