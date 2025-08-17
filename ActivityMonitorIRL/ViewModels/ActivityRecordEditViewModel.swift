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
    
    init(
        hour: Int,
        date: Date,
        initialPoints: Int = 0,
        repository: ActivityRepository = ActivityRepository(),
        onSave: (() -> Void)? = nil
    ) {
        self.hour = hour
        self.date = date
        self.selectedPoints = initialPoints
        self.repository = repository
        self.onSave = onSave
    }
    
    func loadExistingRecord() {
        isLoading = true
        errorMessage = nil
        
        do {
            if let existingRecord = try repository.findByDateAndHour(date, hour: hour) {
                selectedPoints = existingRecord.activityPoints
                activity = existingRecord.activity
            }
        } catch {
            errorMessage = "データの読み込みに失敗しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func saveRecord() {
        guard !isLoading else { return }
        
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
        // 既存レコードがある場合の変更チェック
        do {
            if let existingRecord = try repository.findByDateAndHour(date, hour: hour) {
                return existingRecord.activityPoints != selectedPoints || existingRecord.activity != activity
            } else {
                // 新規レコードの場合、0以外またはactivityが入力されていれば変更あり
                return selectedPoints != 0 || activity != nil
            }
        } catch {
            return selectedPoints != 0 || activity != nil
        }
    }
}
