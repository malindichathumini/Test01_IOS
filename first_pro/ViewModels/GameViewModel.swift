import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // Published properties
    @Published var currentScreen: Screen = .welcome
    @Published var tiles: [GameTile] = []
    @Published var gameState = GameState()
    @Published var settings = GameSettings()
    @Published var selectedMode: GameMode = .colorMatch
    @Published var selectedDifficulty: GameDifficulty = .easy
    
    // Managers
    let highScoreManager = HighScoreManager()
    let soundManager = SoundManager.shared
    let storageManager = StorageManager.shared
    
    // Game state
    private var flippedTiles: [GameTile] = []
    private var timer: Timer?
    private var canFlip = true
    
    init() {
        loadSettings()
    }
    
    // MARK: - Navigation
    func navigateTo(_ screen: Screen) {
        withAnimation {
            currentScreen = screen
        }
        soundManager.playSound(.click)
    }
    
    // MARK: - Game Setup
    func startNewGame() {
        setupGame()
        startTimer()
        navigateTo(.game)
        storageManager.saveLastConfiguration(mode: selectedMode, difficulty: selectedDifficulty)
    }
    
    private func setupGame() {
        // Reset game state
        gameState = GameState()
        gameState.totalPairs = selectedDifficulty.pairsCount
        gameState.timeRemaining = selectedDifficulty.timeLimit
        flippedTiles = []
        canFlip = true
        
        // Generate tiles
        tiles = generateTiles()
    }
    
    private func generateTiles() -> [GameTile] {
        var generatedTiles: [GameTile] = []
        let pairsNeeded = selectedDifficulty.pairsCount
        let colors = ColorPalette.getColors(count: pairsNeeded)
        let shapes = ShapeType.allCases.shuffled()
        
        // Create pairs
        for i in 0..<pairsNeeded {
            let color = colors[i % colors.count]
            let shape = shapes[i % shapes.count]
            
            // Create two matching tiles
            for _ in 0..<2 {
                let tile = GameTile(
                    shape: shape,
                    color: color,
                    pairId: i
                )
                generatedTiles.append(tile)
            }
        }
        
        // Shuffle tiles
        generatedTiles.shuffle()
        
        // Add empty tiles if grid size is larger than needed
        let gridSize = selectedDifficulty.gridSize * selectedDifficulty.gridSize
        let tilesNeeded = pairsNeeded * 2
        
        if tilesNeeded < gridSize {
            // For uneven grids, add dummy tiles that are always matched
            for _ in tilesNeeded..<gridSize {
                var dummyTile = GameTile(
                    shape: .circle,
                    color: .clear,
                    pairId: -1
                )
                dummyTile.isMatched = true
                generatedTiles.append(dummyTile)
            }
            generatedTiles.shuffle()
        }
        
        return generatedTiles
    }
    
    // MARK: - Timer
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        guard gameState.timeRemaining > 0 else {
            endGame(won: false)
            return
        }
        
        gameState.timeRemaining -= 1
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Tile Interaction
    func tileSelected(_ tile: GameTile) {
        guard canFlip,
              !tile.isMatched,
              !tile.isFlipped,
              flippedTiles.count < 2 else {
            return
        }
        
        // Flip tile
        if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
            tiles[index].isFlipped = true
            flippedTiles.append(tiles[index])
            soundManager.playSound(.flip)
            soundManager.vibrate()
            
            // Check for match when 2 tiles are flipped
            if flippedTiles.count == 2 {
                gameState.moves += 1
                canFlip = false
                checkForMatch()
            }
        }
    }
    
    private func checkForMatch() {
        guard flippedTiles.count == 2 else { return }
        
        let tile1 = flippedTiles[0]
        let tile2 = flippedTiles[1]
        
        if tile1.matches(tile2, mode: selectedMode) {
            // Match found!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.handleMatch()
            }
        } else {
            // No match
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.handleNoMatch()
            }
        }
    }
    
    private func handleMatch() {
        // Mark tiles as matched
        for flippedTile in flippedTiles {
            if let index = tiles.firstIndex(where: { $0.id == flippedTile.id }) {
                tiles[index].isMatched = true
            }
        }
        
        gameState.matchedPairs += 1
        gameState.score += 100
        soundManager.playSound(.match)
        soundManager.vibrateSuccess()
        
        flippedTiles.removeAll()
        canFlip = true
        
        // Check win condition
        if gameState.matchedPairs >= gameState.totalPairs {
            endGame(won: true)
        }
    }
    
    private func handleNoMatch() {
        // Flip tiles back
        for flippedTile in flippedTiles {
            if let index = tiles.firstIndex(where: { $0.id == flippedTile.id }) {
                tiles[index].isFlipped = false
            }
        }
        
        flippedTiles.removeAll()
        canFlip = true
    }
    
    // MARK: - Game End
    private func endGame(won: Bool) {
        stopTimer()
        gameState.isGameOver = true
        gameState.isWon = won
        
        if won {
            soundManager.playSound(.win)
            soundManager.vibrateSuccess()
            
            // Calculate final score
            let finalScore = gameState.calculateFinalScore(difficulty: selectedDifficulty)
            gameState.score = finalScore
            
            // Save high score
            let highScore = HighScore(
                score: finalScore,
                mode: selectedMode,
                difficulty: selectedDifficulty,
                moves: gameState.moves,
                timeRemaining: gameState.timeRemaining
            )
            highScoreManager.addScore(highScore)
            storageManager.addToTotalScore(finalScore)
        } else {
            soundManager.playSound(.lose)
            soundManager.vibrateError()
        }
        
        storageManager.incrementGamesPlayed()
        
        // Navigate to results after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.navigateTo(.results)
        }
    }
    
    func restartGame() {
        startNewGame()
    }
    
    func quitGame() {
        stopTimer()
        navigateTo(.menu)
    }
    
    // MARK: - Settings
    func toggleSound() {
        settings.soundEnabled.toggle()
        soundManager.isSoundEnabled = settings.soundEnabled
        saveSettings()
        if settings.soundEnabled {
            soundManager.playSound(.click)
        }
    }
    
    func toggleAnimations() {
        settings.animationsEnabled.toggle()
        saveSettings()
        soundManager.playSound(.click)
    }
    
    func changeTheme(_ theme: GameSettings.Theme) {
        settings.theme = theme
        saveSettings()
        soundManager.playSound(.click)
    }
    
    private func saveSettings() {
        storageManager.saveSettings(settings)
    }
    
    private func loadSettings() {
        settings = storageManager.loadSettings()
        soundManager.isSoundEnabled = settings.soundEnabled
    }
    
    func resetAllData() {
        highScoreManager.clearAll()
        storageManager.resetStatistics()
        soundManager.playSound(.click)
    }
}
