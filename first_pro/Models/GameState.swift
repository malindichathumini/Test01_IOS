import Foundation

struct GameState {
    var score: Int = 0
    var moves: Int = 0
    var timeRemaining: Int = 0
    var matchedPairs: Int = 0
    var totalPairs: Int = 0
    var isGameOver: Bool = false
    var isWon: Bool = false
    
    mutating func calculateFinalScore(difficulty: GameDifficulty) -> Int {
        // Base score from matches
        let matchScore = matchedPairs * 100
        
        // Bonus for time remaining
        let timeBonus = timeRemaining * 10
        
        // Penalty for moves (fewer moves = higher score)
        let moveEfficiency = max(0, (totalPairs * 3) - moves) * 5
        
        // Difficulty multiplier
        let multiplier: Double = {
            switch difficulty {
            case .easy: return 1.0
            case .medium: return 1.5
            case .complex: return 2.0
            }
        }()
        
        let finalScore = Int(Double(matchScore + timeBonus + moveEfficiency) * multiplier)
        return max(0, finalScore)
    }
}

struct GameSettings {
    var soundEnabled: Bool = true
    var animationsEnabled: Bool = true
    var theme: Theme = .system
    
    enum Theme: String, Codable, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
    }
}
