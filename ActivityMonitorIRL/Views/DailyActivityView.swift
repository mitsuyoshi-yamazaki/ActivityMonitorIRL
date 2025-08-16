import SwiftUI

struct PointDefinition {
    let point: Int
    let description: String
}

let pointDefinitions: [PointDefinition] = [
    .init(point: 0, description: "寝ている相当"),
    .init(point: 1, description: "食事風呂家事"),
    .init(point: 2, description: "友達と遊ぶ相当"),
    .init(point: 3, description: "平均的な仕事"),
    .init(point: 4, description: "結構な集中力"),
    .init(point: 5, description: "コンテスト中の集中力"),
    .init(point: 6, description: "リリース直前の集中力")
]

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
                                    displayText: viewModel.getDisplayText(for: hour),
                                    activity: viewModel.getActivity(for: hour)
                                ) {
                                    selectedHour = hour
                                    showingActionSheet = true
                                } onTextInput: {
                                    viewModel.showTextInput(for: hour)
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
            .alert("活動内容を入力", isPresented: $viewModel.isShowingTextInput) {
                TextField("活動内容", text: $viewModel.activityText)
                Button("保存") {
                    viewModel.updateActivity(for: viewModel.selectedHour, activity: viewModel.activityText)
                }
                Button("キャンセル", role: .cancel) {
                    viewModel.hideTextInput()
                }
            } message: {
                Text("\(viewModel.selectedHour)時の活動内容")
            }
        }
    }
    
    private func createActionSheet() -> ActionSheet {
        guard let hour = selectedHour else {
            return ActionSheet(title: Text("エラー"))
        }

        var buttons: [ActionSheet.Button] = pointDefinitions.map { definition in
                .default(Text("\(definition.point)pt: \(definition.description)")) {
                    viewModel.updatePoints(for: hour, points: definition.point)
            }
        } + [.cancel(Text("キャンセル"))]

        // 0時から選択中の時刻まで全てのActivityRecordが生成されていない場合
        let allRecordsMissing = (0...hour).allSatisfy { viewModel.hourlyRecords[$0] == nil }
        
        if allRecordsMissing {
            buttons.insert(
                .default(Text("起床")) {
                    viewModel.updatePointsForMultipleHours(hours: Array(0...hour), points: 0)
                },
                at: 0
            )
        }

        return ActionSheet(
            title: Text("\(hour)時の活動スコア入力"),
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
