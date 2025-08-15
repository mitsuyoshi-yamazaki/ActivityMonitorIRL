import SwiftUI

struct DailyActivityView: View {
    @StateObject private var viewModel = DailyActivityViewModel()
    @State private var selectedHour: Int?
    @State private var showingActionSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    List {
                        ForEach(0..<24, id: \.self) { hour in
                            HourRow(
                                hour: hour,
                                displayText: viewModel.getDisplayText(for: hour)
                            ) {
                                selectedHour = hour
                                showingActionSheet = true
                            }
                            .listRowSeparator(.visible)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(viewModel.dateFormatter.string(from: viewModel.selectedDate))
            .navigationBarTitleDisplayMode(.large)
            .actionSheet(isPresented: $showingActionSheet) {
                createActionSheet()
            }
        }
    }
    
    private func createActionSheet() -> ActionSheet {
        guard let hour = selectedHour else {
            return ActionSheet(title: Text("エラー"))
        }
        
        let buttons: [ActionSheet.Button] = (0...6).map { point in
            .default(Text("\(point)ポイント")) {
                viewModel.updatePoints(for: hour, points: point)
            }
        } + [.cancel(Text("キャンセル"))]
        
        return ActionSheet(
            title: Text("\(hour):00の活動ポイント"),
            message: Text("0〜6ポイントから選択してください"),
            buttons: buttons
        )
    }
}

#Preview {
    DailyActivityView()
}