import SwiftUI

struct ActivityRecordEditViewDemo: View {
    @State private var showingEditView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("ActivityRecordEditView デモ")
                    .font(.title)
                    .padding()
                
                Button("15時の編集画面を表示") {
                    showingEditView = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
            }
            .navigationTitle("デモ")
        }
        .sheet(isPresented: $showingEditView) {
            ActivityRecordEditView(hour: 15, initialPoints: 3)
                .presentationDetents([.height(450)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ActivityRecordEditViewDemo()
}