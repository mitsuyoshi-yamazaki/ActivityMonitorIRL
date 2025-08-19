//
//  ActivityMonitorIRLApp.swift
//  ActivityMonitorIRL
//
//  Created by Yamazaki Mitsuyoshi on 2025/08/15.
//

import SwiftUI

@main
struct ActivityMonitorIRLApp: App {
    @State private var shouldShowQuickRecord = false
    @State private var quickRecordHour: Int?
    
    var body: some Scene {
        WindowGroup {
            MainTabView(
                shouldShowQuickRecord: shouldShowQuickRecord,
                quickRecordHour: quickRecordHour
            )
            .onOpenURL { url in
                handleURL(url)
            }
        }
    }
    
    private func handleURL(_ url: URL) {
        guard url.scheme == "activitymonitor",
              url.host == "quickrecord" else {
            return
        }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let hour = components?.queryItems?.first(where: { $0.name == "hour" })?.value.flatMap(Int.init)
            ?? Calendar.current.component(.hour, from: Date())
        
        quickRecordHour = hour
        shouldShowQuickRecord = true
        
        // フラグをリセット（次回の起動のため）
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            shouldShowQuickRecord = false
            quickRecordHour = nil
        }
    }
}
