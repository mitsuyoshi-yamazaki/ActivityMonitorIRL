import SwiftUI

struct SelectedRecord: Identifiable {
    let id = UUID()
    let hour: Int
    let date: Date
}

struct DailyActivityView: View {
    @StateObject private var viewModel: DailyActivityViewModel
    @State private var selectedRecord: SelectedRecord?
    @Environment(\.scenePhase) var scenePhase
    
    let shouldShowQuickRecord: Bool
    let quickRecordHour: Int?
    
    init(initialDate: Date? = nil, shouldShowQuickRecord: Bool = false, quickRecordHour: Int? = nil) {
        self._viewModel = StateObject(wrappedValue: DailyActivityViewModel(initialDate: initialDate))
        self.shouldShowQuickRecord = shouldShowQuickRecord
        self.quickRecordHour = quickRecordHour
    }
    
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
                                    selectedRecord = SelectedRecord(hour: hour, date: viewModel.selectedDate)
                                }
                                .listRowSeparator(.visible)
                                .id(hour)
                            }
                        }
                        .listStyle(.plain)
                        .onAppear {
                            scrollToCurrentHourIfNeeded(proxy: proxy)
                            handleQuickRecord()
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
            .sheet(item: $selectedRecord) { record in
                ActivityRecordEditView(
                    hour: record.hour,
                    date: record.date,
                    initialPoints: getCurrentPoints(for: record.hour)
                ) {
                    viewModel.loadActivityRecords(for: viewModel.selectedDate)
                }
                .presentationDetents([.height(450)])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func getCurrentPoints(for hour: Int) -> Int {
        return viewModel.hourlyRecords[hour]?.activityPoints ?? 0
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
    
    private func handleQuickRecord() {
        if shouldShowQuickRecord, let hour = quickRecordHour {
            // 今日の日付に設定
            let today = Date()
            if !Calendar.current.isDate(today, equalTo: viewModel.selectedDate, toGranularity: .day) {
                viewModel.changeDate(to: today)
            }
            
            // モーダルを表示
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                selectedRecord = SelectedRecord(hour: hour, date: today)
            }
        }
    }
}

#Preview {
    DailyActivityView()
}
