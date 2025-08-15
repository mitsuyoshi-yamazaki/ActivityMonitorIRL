import SwiftUI

struct DailyActivityView: View {
    @StateObject private var viewModel = DailyActivityViewModel()
    @State private var selectedHour: Int?
    @State private var showingActionSheet = false
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    ScrollViewReader { proxy in
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
                                .id(hour)
                            }
                        }
                        .listStyle(.plain)
                        .onAppear {
                            scrollToCurrentHourIfNeeded(proxy: proxy)
                        }
                        .onChange(of: scenePhase) { newPhase in
                            if newPhase == .active {
                                scrollToCurrentHourIfNeeded(proxy: proxy)
                            }
                        }
                    }
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
    
    private func scrollToCurrentHourIfNeeded(proxy: ScrollViewProxy) {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        // 現在時刻のActivityRecordが存在しない場合のみスクロール
        if viewModel.getDisplayText(for: currentHour) == "-" && !viewModel.isLoading {
            withAnimation(.easeInOut(duration: 0.5)) {
                proxy.scrollTo(currentHour, anchor: .center)
            }
        }
    }
}

#Preview {
    DailyActivityView()
}