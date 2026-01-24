import Foundation
import Combine

struct HighScore: Codable, Identifiable {
    let id: UUID
    let score: Int
    let mode: GameMode
    let difficulty: GameDifficulty
    let date: Date
    let moves: Int
    let timeRemaining: Int
    
    init(score: Int, mode: GameMode, difficulty: GameDifficulty, moves: Int, timeRemaining: Int) {
        self.id = UUID()
        self.score = score
        self.mode = mode
        self.difficulty = difficulty
        self.date = Date()
        self.moves = moves
        self.timeRemaining = timeRemaining
    }
}

class HighScoreManager: ObservableObject {
    @Published var scores: [HighScore] = []
    private let maxScoresPerCategory = 10
    
    init() {
        loadScores()
    }
    
    func addScore(_ score: HighScore) {
        scores.append(score)
        scores.sort { $0.score > $1.score }
        
        // Keep only top scores per mode/difficulty combination
        var filteredScores: [HighScore] = []
        var counts: [String: Int] = [:]
        
        for score in scores {
            let key = "\(score.mode.rawValue)-\(score.difficulty.rawValue)"
            let count = counts[key, default: 0]
            
            if count < maxScoresPerCategory {
                filteredScores.append(score)
                counts[key] = count + 1
            }
        }
        
        scores = filteredScores
        saveScores()
    }
    
    func getScores(for mode: GameMode, difficulty: GameDifficulty) -> [HighScore] {
        scores.filter { $0.mode == mode && $0.difficulty == difficulty }
            .sorted { $0.score > $1.score }
    }
    
    func getTopScore(for mode: GameMode, difficulty: GameDifficulty) -> Int? {
        getScores(for: mode, difficulty: difficulty).first?.score
    }
    
    func clearAll() {
        scores.removeAll()
        saveScores()
    }
    
    private func saveScores() {
        if let encoded = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(encoded, forKey: "highScores")
        }
    }
    
    private func loadScores() {
        if let data = UserDefaults.standard.data(forKey: "highScores"),
           let decoded = try? JSONDecoder().decode([HighScore].self, from: data) {
            scores = decoded
        }
    }
}
