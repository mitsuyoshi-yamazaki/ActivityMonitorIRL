import SwiftUI

struct HistorySummaryView: View {
    @StateObject private var viewModel = HistorySummaryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if viewModel.dailySummaries.isEmpty {
                    VStack {
                        Text("活動記録がありません")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding()
                        
                        Button("更新") {
                            viewModel.refresh()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.dailySummaries) { summary in
                            NavigationLink(
                                destination: DailyActivityView(initialDate: summary.date)
                            ) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(viewModel.formatDate(summary.date))
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        
                                        Text("\(summary.totalActivityPoints)pt")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        viewModel.refresh()
                    }
                }
            }
            .navigationTitle("履歴集計")
            .onAppear {
                viewModel.refresh()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistorySummaryView()
    }
}