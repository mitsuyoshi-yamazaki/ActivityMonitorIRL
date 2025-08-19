import AppIntents

struct ActivityShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: QuickRecordActivityIntent(),
            phrases: [
                "活動記録を開く",
                "\(.applicationName)で活動記録",
                "アクティビティを記録",
                "今の活動を記録"
            ],
            shortTitle: "活動記録",
            systemImageName: "plus.circle.fill"
        )
    }
}