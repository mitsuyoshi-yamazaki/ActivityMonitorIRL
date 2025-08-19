import AppIntents
import Foundation

struct QuickRecordActivityIntent: AppIntent {
    static var title: LocalizedStringResource = "活動記録を開く"
    static var description = IntentDescription("現在時刻の活動記録画面を素早く開きます")
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let urlString = "activitymonitor://quickrecord?hour=\(currentHour)"
        
        guard let url = URL(string: urlString) else {
            throw IntentError.general
        }
        
        return .result(
            opensIntent: OpenURLIntent(url),
            dialog: "活動記録画面を開いています..."
        )
    }
}