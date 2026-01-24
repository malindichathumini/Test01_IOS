import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // Keys
    private enum Keys {
        static let soundEnabled = "soundEnabled"
        static let animationsEnabled = "animationsEnabled"
        static let theme = "theme"
        static let lastMode = "lastGameMode"
        static let lastDifficulty = "lastGameDifficulty"
        static let gamesPlayed = "totalGamesPlayed"
        static let totalScore = "totalScore"
    }
    
    // Save Settings - Simplified (no encoding)
    func saveSettings(_ settings: GameSettings) {
        defaults.set(settings.soundEnabled, forKey: Keys.soundEnabled)
        defaults.set(settings.animationsEnabled, forKey: Keys.animationsEnabled)
        defaults.set(settings.theme.rawValue, forKey: Keys.theme)
    }
    
    func loadSettings() -> GameSettings {
        let soundEnabled = defaults.object(forKey: Keys.soundEnabled) as? Bool ?? true
        let animationsEnabled = defaults.object(forKey: Keys.animationsEnabled) as? Bool ?? true
        let themeString = defaults.string(forKey: Keys.theme) ?? "System"
        let theme = GameSettings.Theme(rawValue: themeString) ?? .system
        
        return GameSettings(soundEnabled: soundEnabled, animationsEnabled: animationsEnabled, theme: theme)
    }
    
    // Save last played configuration
    func saveLastConfiguration(mode: GameMode, difficulty: GameDifficulty) {
        defaults.set(mode.rawValue, forKey: Keys.lastMode)
        defaults.set(difficulty.rawValue, forKey: Keys.lastDifficulty)
    }
    
    func loadLastConfiguration() -> (GameMode, GameDifficulty)? {
        guard let modeString = defaults.string(forKey: Keys.lastMode),
              let difficultyString = defaults.string(forKey: Keys.lastDifficulty),
              let mode = GameMode(rawValue: modeString),
              let difficulty = GameDifficulty(rawValue: difficultyString) else {
            return nil
        }
        return (mode, difficulty)
    }
    
    // Statistics
    func incrementGamesPlayed() {
        let current = defaults.integer(forKey: Keys.gamesPlayed)
        defaults.set(current + 1, forKey: Keys.gamesPlayed)
    }
    
    func getGamesPlayed() -> Int {
        return defaults.integer(forKey: Keys.gamesPlayed)
    }
    
    func addToTotalScore(_ score: Int) {
        let current = defaults.integer(forKey: Keys.totalScore)
        defaults.set(current + score, forKey: Keys.totalScore)
    }
    
    func getTotalScore() -> Int {
        return defaults.integer(forKey: Keys.totalScore)
    }
    
    func resetStatistics() {
        defaults.set(0, forKey: Keys.gamesPlayed)
        defaults.set(0, forKey: Keys.totalScore)
    }
}
