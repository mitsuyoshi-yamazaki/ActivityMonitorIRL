import SwiftUI

struct ActivityRecordEditView: View {
    let hour: Int
    
    @State private var selectedPoints: Int
    @Environment(\.dismiss) private var dismiss
    
    init(hour: Int, initialPoints: Int = 0) {
        self.hour = hour
        self._selectedPoints = State(initialValue: initialPoints)
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
    }
    
    private var header: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            Text("\(hour)時の活動スコア入力")
                .font(.headline)
                .padding(.vertical, 16)
        }
        .background(Color(.systemGray6))
        .cornerRadius(16, corners: [.topLeft, .topRight])
    }
    
    private var content: some View {
        VStack(spacing: 24) {
            // Discrete Slider
            discreteSlider
            
            // 説明文
            descriptionText
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    private var discreteSlider: some View {
        VStack(spacing: 16) {
            Text("活動レベル: \(selectedPoints)")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 0) {
                ForEach(0...6, id: \.self) { point in
                    Button(action: {
                        selectedPoints = point
                    }) {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(selectedPoints == point ? Color.accentColor : Color(.systemGray4))
                                .frame(width: 32, height: 32)
                            
                            Text("\(point)")
                                .font(.caption)
                                .foregroundColor(selectedPoints == point ? .primary : .secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var descriptionText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("説明")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(currentDescription)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
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
                    // TODO: 保存処理
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    private var currentDescription: String {
        pointDefinitions.first { $0.point == selectedPoints }?.description ?? "不明"
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
    ActivityRecordEditView(hour: 15, initialPoints: 3)
        .presentationDetents([.height(400)])
}
