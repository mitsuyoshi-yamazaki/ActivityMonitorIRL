import SwiftUI
import Foundation

class ActivityRecordEditViewModel: ObservableObject {
    @Published var selectedPoints: Int
    @Published var activity: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSaved = false
    
    let hour: Int
    let date: Date
    private let repository: ActivityRepository
    private let onSave: (() -> Void)?

    // 初期データを保持してDB読み込みを最適化
    private var initialPoints: Int?
    private var initialActivity: String?
    
    init(
        placeholder: ActivityRecordPlaceholder,
        repository: ActivityRepository = ActivityRepository(),
        onSave: (() -> Void)? = nil
    ) {
        switch placeholder {
        case .noRecord(let date, let hour):
            self.date = date
            self.hour = hour
            selectedPoints = 0
            activity = nil
            initialPoints = nil
            initialActivity = nil
        case .hasRecord(let record):
            date = record.date
            hour = record.hour
            selectedPoints = record.activityPoints
            activity = record.activity
            initialPoints = record.activityPoints
            initialActivity = record.activity
        }

        self.repository = repository
        self.onSave = onSave
    }

    func loadExistingRecord() {
        guard !isLoading else {
            print("\(date) \(hour) はロード中です")
            return
        }
        isLoading = true
        errorMessage = nil
        
        do {
            if let existingRecord = try repository.findByDateAndHour(date, hour: hour) {
                selectedPoints = existingRecord.activityPoints
                activity = existingRecord.activity
                
                // 初期データを更新（既存レコードがある場合）
                initialPoints = existingRecord.activityPoints
                initialActivity = existingRecord.activity
            }
        } catch {
            errorMessage = "データの読み込みに失敗しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func saveRecord() {
        guard !isLoading else {
            print("\(date) \(hour) は保存中です")
            return
        }

        isLoading = true
        errorMessage = nil
        
        let record = ActivityRecord(
            date: date,
            hour: hour,
            activityPoints: selectedPoints,
            activity: activity
        )
        
        do {
            try repository.save(record)
            isSaved = true
            onSave?()
        } catch {
            errorMessage = "保存に失敗しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var currentDescription: String {
        pointDefinitions.first { $0.point == selectedPoints }?.description ?? "不明"
    }
    
    var titleText: String {
        "\(hour)時の活動スコア入力"
    }
    
    var hasChanges: Bool {
        return initialPoints != selectedPoints || initialActivity != activity
    }
}
