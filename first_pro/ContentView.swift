import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: backgroundColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Group {
                switch gameViewModel.currentScreen {
                case .welcome:
                    WelcomeView()
                case .menu:
                    MenuView()
                case .modeSelection:
                    GameModeSelectionView()
                case .difficultySelection:
                    DifficultySelectionView()
                case .game:
                    GameView()
                case .results:
                    ResultsView()
                case .highScores:
                    HighScoresView()
                case .settings:
                    SettingsView()
                }
            }
            .transition(.opacity.combined(with: .scale))
        }
        .animation(.easeInOut(duration: 0.3), value: gameViewModel.currentScreen)
    }
    
    var backgroundColors: [Color] {
        switch gameViewModel.settings.theme {
        case .dark:
            return [Color(hex: "1a1a2e"), Color(hex: "16213e")]
        case .light:
            return [Color(hex: "e0c3fc"), Color(hex: "8ec5fc")]
        case .system:
            return [Color(hex: "667eea"), Color(hex: "764ba2")]
        }
    }
}

enum Screen {
    case welcome, menu, modeSelection, difficultySelection, game, results, highScores, settings
}
