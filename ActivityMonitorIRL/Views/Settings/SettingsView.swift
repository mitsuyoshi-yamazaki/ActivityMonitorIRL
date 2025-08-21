import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section("アプリ情報") {
                HStack {
                    Text("バージョン")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("データ管理") {
                Text("データのエクスポート")
                Text("データのインポート")
                Text("データのリセット")
                    .foregroundColor(.red)
            }
            
            Section("その他") {
                Text("プライバシーポリシー")
                Text("利用規約")
                Text("お問い合わせ")
            }
        }
        .navigationTitle("設定")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
