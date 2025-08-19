import AppIntents
import Foundation

// MARK: - App Intent Definition
struct QuickRecordActivityIntent: AppIntent {
    struct QuickRecordActivityIntentError: Error {}

    static var title: LocalizedStringResource = "活動記録を開く"
    static var description = IntentDescription("現在時刻の活動記録画面を素早く開きます")
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let urlString = "activitymonitor://quickrecord?hour=\(currentHour)"
        
        guard let url = URL(string: urlString) else {
            throw QuickRecordActivityIntentError()
        }
        
        return .result(
            opensIntent: OpenURLIntent(url),
            dialog: "活動記録画面を開いています..."
        )
    }
}

// MARK: - App Shortcuts Provider
struct ActivityShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: QuickRecordActivityIntent(),
            phrases: [
                "\(.applicationName)で活動記録を開く",
                "\(.applicationName)で活動記録",
                "\(.applicationName)でアクティビティを記録",
                "\(.applicationName)で今の活動を記録"
            ],
            shortTitle: "活動記録",
            systemImageName: "plus.circle.fill"
        )
    }
}