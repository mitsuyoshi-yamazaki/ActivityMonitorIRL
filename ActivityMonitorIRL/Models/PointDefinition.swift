import Foundation

struct PointDefinition {
    let point: Int
    let description: String
}

let pointDefinitions: [PointDefinition] = [
    .init(point: 0, description: "寝ている相当"),
    .init(point: 1, description: "食事風呂家事"),
    .init(point: 2, description: "友達と遊ぶ相当"),
    .init(point: 3, description: "平均的な仕事"),
    .init(point: 4, description: "結構な集中力"),
    .init(point: 5, description: "コンテスト中の集中力"),
    .init(point: 6, description: "リリース直前の集中力")
]
