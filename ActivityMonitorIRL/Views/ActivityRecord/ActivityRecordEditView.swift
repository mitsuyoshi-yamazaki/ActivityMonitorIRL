import SwiftUI

struct ActivityRecordEditView: View {
    @StateObject private var viewModel: ActivityRecordEditViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(hour: Int, date: Date, initialPoints: Int = 0, onSave: (() -> Void)? = nil) {
        self._viewModel = StateObject(wrappedValue: ActivityRecordEditViewModel(
            hour: hour,
            date: date,
            initialPoints: initialPoints,
            onSave: onSave
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            header
            
            // コンテンツ
            content
            
            // フッター
            footer
        }
        .background(Color(.systemBackground))
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .onAppear {
            viewModel.loadExistingRecord()
        }
        .onChange(of: viewModel.isSaved) { saved in
            if saved {
                dismiss()
            }
        }
    }
    
    private var header: some View {
        VStack {
            Text(viewModel.titleText)
                .font(.headline)
                .padding(.vertical, 16)
        }
        .background(Color(.systemGray2))
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
    
    private var content: some View {
        VStack(spacing: 24) {
            // Discrete Slider
            discreteSlider
            
            // 説明文
            descriptionText
            
            // 活動内容入力
            activityTextField
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    private var discreteSlider: some View {
        VStack(spacing: 16) {
            Text("活動スコア: \(viewModel.selectedPoints)pt")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 0) {
                ForEach(0...6, id: \.self) { point in
                    Button(
                        action: {
                            viewModel.selectedPoints = point
                        },
                        label: {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(viewModel.selectedPoints == point ? Color.accentColor : Color(.systemGray4))
                                .frame(width: 32, height: 32)
                            
                            Text("\(point)")
                                .font(.caption)
                                .foregroundColor(viewModel.selectedPoints == point ? .primary : .secondary)
                        }
                    })
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var descriptionText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.currentDescription)
                .font(.body)
                .fontWeight(.light)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)

        }
    }
    
    private var activityTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("活動内容")
                .font(.headline)
                .foregroundColor(.secondary)
            
            TextField("活動内容を入力（任意）", text: Binding(
                get: { viewModel.activity ?? "" },
                set: { newValue in
                    viewModel.activity = newValue.isEmpty ? nil : newValue
                }
            ))
            .textFieldStyle(.roundedBorder)
            .font(.body)
        }
    }
    
    private var footer: some View {
        VStack(spacing: 16) {
            Divider()
            
            HStack(spacing: 16) {
                Button("キャンセル") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(.systemGray5))
                .foregroundColor(.primary)
                .cornerRadius(8)
                
                Button("保存") {
                    viewModel.saveRecord()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(viewModel.hasChanges ? Color.accentColor : Color(.systemGray4))
                .foregroundColor(viewModel.hasChanges ? .white : .secondary)
                .cornerRadius(8)
                .disabled(!viewModel.hasChanges)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ActivityRecordEditView(hour: 15, date: Date(), initialPoints: 3)
        .presentationDetents([.height(400)])
}
