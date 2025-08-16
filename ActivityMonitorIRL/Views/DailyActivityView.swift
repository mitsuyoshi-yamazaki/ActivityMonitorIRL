import SwiftUI

struct DailyActivityView: View {
    @StateObject private var viewModel = DailyActivityViewModel()
    @State private var selectedHour: Int?
    @State private var showingActionSheet = false
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle(viewModel.getTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.changeToPreviousDate()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.changeToNextDate()
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
            }
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

        if viewModel.isWakeUpHour(hour: hour) {
            buttons.insert(
                .default(Text("起床")) {
                    viewModel.createSleepActivities(wakeUpHour: hour)
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
