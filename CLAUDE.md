# CLAUDE.md - ActivityMonitorIRL

## プロジェクト概要

### 基本情報
- **プラットフォーム**: iOS
- **最小サポートバージョン**: iOS 16.0+
- **開発言語**: Swift 5.9+
- **IDE**: Xcode 15.0+
- **プロジェクト名**: ActivityMonitorIRL
- **Bundle Identifier**: com.yourdomain.activitymonitorirl
- **開発チーム**: 個人開発

### アプリケーション要件
- **主要機能**: 毎日毎時間の活動量記録・集計アプリ
- **ターゲットユーザー**: 日常の活動量を詳細に記録・管理したい個人
- **ビジネスモデル**: 無料アプリ（個人利用）

### 機能詳細
#### 活動量記録機能
- **記録単位**: 時間別（1日24時間）
- **ポイント制**: 各時間に0〜6ポイントを設定
- **入力優先**: 最も重要視される項目は入力の容易さ
- **データ範囲**: 過去・現在・未来の日付に対応

#### 集計・表示機能
- **日別集計**: 1日の総ポイント表示
- **週別集計**: 週単位での活動量推移
- **月別集計**: 月単位での活動量推移
- **グラフ表示**: 時系列での活動量可視化

#### ユーザビリティ要件
- **タップ操作**: 最小タップ数での入力完了
- **直感的UI**: 説明不要の操作インターフェース
- **高速起動**: アプリ起動から入力まで2秒以内
- **オフライン**: ネットワーク不要での完全動作

## 技術スタック

### コア技術
| 技術 | 選定理由 | バージョン |
|------|---------|------------|
| **SwiftUI** | 宣言的UIフレームワーク | iOS 16+ |
| **ObservableObject + @Published** | シンプルな状態管理、学習コスト最小 | - |
| **SQLite.swift** | プリミティブで柔軟なDB操作、ORM的な使用が可能 | 0.14.0+ |
| **Swift Package Manager** | Apple公式、依存管理のシンプルさ | - |
| **Mint** | 開発ツールのバージョン管理 | latest |

### 開発ツール
| ツール | 用途 | バージョン |
|--------|------|------------|
| **SwiftLint** | コード品質チェック | 0.54.0 |

## アーキテクチャ

### レイヤー構造
```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│     (SwiftUI + ViewModel)          │
├─────────────────────────────────────┤
│          Business Layer             │
│     (UseCase - 未定義)             │
├─────────────────────────────────────┤
│           Data Layer                │
│   (Repository + SQLite.swift)      │
└─────────────────────────────────────┘
```

### ディレクトリ構造
```
ActivityMonitorIRL/
├── Models/
│   └── ActivityRecord.swift           # 活動記録モデル
├── ViewModels/
│   └── DailyActivityViewModel.swift   # 日別画面の状態管理
├── Views/
│   ├── DailyActivityView.swift        # 日別記録画面
│   └── Components/
│       └── HourRow.swift              # 時刻行コンポーネント
├── Database/
│   └── DatabaseManager.swift          # SQLite接続管理
├── Repositories/
│   └── ActivityRepository.swift       # データアクセス層
└── Extensions/
    └── Date+SQLite.swift              # Date型SQLite対応
```

## 実装済み機能

### データ構造
- **ActivityRecord**: 日付・時間(0-23)・活動量(0-6)のモデル、(date,hour)複合主キー
- **DatabaseManager**: SQLite接続管理、Documents/ActivityMonitor.sqliteに保存
- **ActivityRepository**: CRUD操作とバリデーション、ActivityRecord専用データアクセス
- **Date+SQLite**: Date型のValue実装、ISO8601形式でSQLite保存

### 画面構造
- **DailyActivityView**: 日別活動記録メイン画面、24時間テーブル表示
- **DailyActivityViewModel**: ObservableObject状態管理、Repository連携とリアルタイム更新
- **HourRow**: 時刻行コンポーネント、"時刻 | ポイント数"表示とタップ操作
- **ActionSheet**: 0-6ポイントワンタップ入力UI

### データフロー
1. 起動時：ViewModel→Repository→SQLite、当日データ自動読み込み
2. 入力時：タップ→ActionSheet→ViewModel→Repository→SQLite→UI更新
3. 表示時：存在時ポイント数、未記録時"-"表示

## 開発環境セットアップ

### 前提条件
- macOS 13.0+
- Xcode 15.0+
- Homebrew インストール済み

### 初回セットアップ手順
TBD

## テスト戦略

### Unit Test
- 初期バージョンでは不要

### UI Test
- 不要

### Integration Test
- 手動にて実行

## CI/CD
- 不要

### 環境変数
- なし

## セキュリティ

### データ保護
- **App Transport Security**: 設定
- **Keychain使用**: なし
- **バイオメトリクス認証**: 　なし

## リリース
- TBD

### バージョニング
- **形式**: Semantic Versioning
- **ビルド番号**: 正の整数：Productionビルド時に更新
