import Foundation

// MARK: - Word Bank
let wordBank: [String: [String]] = [
    "음식": ["피자", "치킨", "라면", "김밥", "떡볶이", "삼겹살", "냉면", "비빔밥", "초밥", "파스타"],
    "영화": ["인터스텔라", "어벤져스", "기생충", "타이타닉", "해리포터", "라라랜드", "노팅힐", "매트릭스", "알라딘", "겨울왕국"],
    "동물": ["강아지", "고양이", "토끼", "사자", "호랑이", "코끼리", "기린", "펭귄", "독수리", "돌고래"]
]

// MARK: - 게임 전반 설정을 저장하는 모델
struct GameSettings {
    var totalPlayers: Int = 4
    var liarCount: Int = 1
    var category: String = "음식"
}

// MARK: - 각 플레이어에게 분배될 개별 역할 모델
struct PlayerRole {
    var playerNumber: Int
    var isLiar: Bool
    var keyword: String  // 시민: 제시어 / 라이어: "라이어!"
}

// MARK: - 역할 생성 로직
func generateRoles(settings: GameSettings) -> [PlayerRole] {
    let words = wordBank[settings.category] ?? ["사과"]
    let keyword = words.randomElement() ?? "사과"

    var indices = Array(0..<settings.totalPlayers)
    indices.shuffle()
    let liarIndices = Set(indices.prefix(settings.liarCount))

    return (0..<settings.totalPlayers).map { i in
        let isLiar = liarIndices.contains(i)
        return PlayerRole(
            playerNumber: i + 1,
            isLiar: isLiar,
            keyword: isLiar ? "🤥 라이어!" : keyword
        )
    }
}
