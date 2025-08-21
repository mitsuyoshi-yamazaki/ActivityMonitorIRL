# ActivityMonitorIRL - Lock Screen Widget 実装ガイド

## 概要
ActivityMonitorIRLアプリにロック画面ウィジェット機能を追加するための完全な実装ガイドです。

## 実装済みファイル

### 1. 共有データベース基盤
- **SharedDatabaseManager.swift** (Main Appに追加済み)
  - App Groups対応の共有SQLiteデータベース管理
  - 既存データベースからの自動移行機能
  - Widget用軽量データ取得API

### 2. Widget Extension ファイル群 (WidgetFiles/ フォルダ内)
- **WidgetActivityRepository.swift** - Widget用データアクセス層
- **ActivityMonitorWidget.swift** - Widget Configuration & Timeline Provider
- **AccessoryCircularView.swift** - Lock Screen Widget UI (円形・矩形・インライン)
- **ActivityMonitorWidgetBundle.swift** - Widget Bundle Main
- **Info.plist** - Widget Extension用設定ファイル

### 3. Main App 統合
- **ActivityMonitorIRLApp.swift** - Widget起動URL処理追加済み
- **Info.plist** - Bundle ID更新済み (mitsuyoshi.activitymonitorirl)
- **DatabaseManager.swift** - 共有DB移行処理追加済み

## Xcodeでの手動作業

### ステップ1: Widget Extension ターゲット追加
1. Xcodeでプロジェクトを開く
2. プロジェクト設定 → TARGETS → + ボタン → Widget Extension
3. 以下設定で作成:
   - Product Name: `ActivityMonitorWidget`
   - Bundle Identifier: `mitsuyoshi.activitymonitorirl.widget`
   - Language: Swift
   - Include Live Activity: ❌
   - Include Control: ❌
   - Include App Intent: ❌

### ステップ2: ファイル移行
`WidgetFiles/` フォルダ内の全ファイルを新しく作成された Widget Extension ターゲットに移動:

**自動生成されたファイルを置き換え:**
- `ActivityMonitorWidget.swift` → 実装済みファイルで置き換え
- `ActivityMonitorWidgetBundle.swift` → 実装済みファイルで置き換え
- `Info.plist` → 実装済みファイルで置き換え

**新規追加:**
- `WidgetActivityRepository.swift`
- `AccessoryCircularView.swift`

### ステップ3: App Groups 設定
**Main App ターゲット:**
1. Signing & Capabilities → + Capability → App Groups
2. Group identifier: `group.mitsuyoshi.activitymonitorirl` を追加

**Widget Extension ターゲット:**
1. 同様に App Groups capability を追加
2. 同じ Group identifier を選択

### ステップ4: 共有ファイル設定
**SharedDatabaseManager.swift を両ターゲットに追加:**
1. SharedDatabaseManager.swift を選択
2. File Inspector → Target Membership
3. ✅ ActivityMonitorIRL (Main App)
4. ✅ ActivityMonitorWidget (Widget Extension)

**SQLite.swift フレームワークをWidget Extensionに追加:**
1. Widget Extension ターゲットを選択
2. Build Phases → Link Binary With Libraries → +
3. SQLite.swift を追加

### ステップ5: ActivityRecord モデル共有
既存の `ActivityRecord.swift` を Widget Extension ターゲットにも追加:
1. ActivityRecord.swift を選択
2. Target Membership で Widget Extension にもチェック

## 動作仕様

### Widget表示内容
- **Circular (円形)**: 今日の総ポイント数
- **Rectangular (矩形)**: 今日の総ポイント + 現在時刻の活動状況
- **Inline (インライン)**: 「活動: XXpt (現在時刻の状況)」

### Deep Link 動作
1. **ウィジェットタップ**: `activitymonitor://widget-quickrecord?hour=現在時刻`
2. **アプリ起動**: DailyActivityView タブ選択
3. **日付設定**: 今日の日付
4. **モーダル表示**: 現在時刻のActivityRecordEditView

### データ更新頻度
- Timeline更新: 15分間隔
- データソース: 共有SQLiteデータベース
- バックグラウンド制限: iOS標準制限に準拠

## トラブルシューティング

### Widget が表示されない場合
1. Widget Extension のBundle IDが正しいか確認
2. App Groups設定が両ターゲットで一致しているか確認
3. SQLite.swiftがWidget Extensionにリンクされているか確認

### データが表示されない場合
1. SharedDatabaseManager.swiftが両ターゲットに追加されているか確認
2. ActivityRecord.swiftがWidget Extensionで使用可能か確認
3. App Groups containerが正しくアクセスできているか確認

### Deep Link が動作しない場合
1. Main App の Info.plist にURL Schemeが設定されているか確認
2. ActivityMonitorIRLApp.swift のURL処理が更新されているか確認

## セキュリティ考慮事項
- App Groups による適切なデータ分離
- Widget では表示のみ、編集は Main App で実行
- SQLite.swift による型安全なデータアクセス

## パフォーマンス最適化
- Widget用軽量Repository パターン
- 必要最小限のデータのみ取得
- 効率的なTimeline更新戦略

この実装により、ActivityMonitorIRLにプロフェッショナルレベルのLock Screen Widget機能が追加されます。