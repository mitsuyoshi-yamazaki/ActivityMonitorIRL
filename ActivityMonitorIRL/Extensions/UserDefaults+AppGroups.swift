//
//  UserDefaults+AppGroups.swift
//  ActivityMonitorIRL
//
//  Created by Yamazaki Mitsuyoshi on 2025/08/21.
//

import Foundation

extension UserDefaults {
    typealias TodaySummary = [Int: Int] // キーは0〜23

    // swiftlint:disable:next force_unwrapping
    static let appGroup = UserDefaults(suiteName: "group.mitsuyoshi.activitymonitorirl")!

    var todaySummary: TodaySummary? {
        get {
            guard let data = data(forKey: "today_summary") else {
                return nil
            }
            return try? JSONDecoder().decode(TodaySummary.self, from: data)
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            set(data, forKey: "today_summary")
        }
    }
}
