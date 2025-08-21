import SwiftUI
import Foundation

class SettingsViewModel: ObservableObject {
    @Published var appVersion: String = "1.0.0"
    @Published var buildNumber: String = "1"
    
    init() {
        loadAppInfo()
    }
    
    private func loadAppInfo() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            buildNumber = build
        }
    }
    
    func exportData() {
        
    }
    
    func importData() {
        
    }
    
    func resetAllData() {
        
    }
    
    func openPrivacyPolicy() {
        
    }
    
    func openTermsOfService() {
        
    }
    
    func openSupport() {
        
    }
}
