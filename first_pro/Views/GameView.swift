import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with stats
            VStack(spacing: 15) {
                // Top bar
                HStack {
                    Button {
                        viewModel.quitGame()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    // Mode indicator
                    Text(viewModel.selectedMode.rawValue)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.purple.opacity(0.2))
                        .foregroundColor(.purple)
                        .cornerRadius(10)
                }
                
                // Stats
                HStack(spacing: 20) {
                    StatView(
                        icon: "clock.fill",
                        value: timeString,
                        label: "Time",
                        color: timeColor
                    )
                    
                    StatView(
                        icon: "target",
                        value: "\(viewModel.gameState.matchedPairs)/\(viewModel.gameState.totalPairs)",
                        label: "Pairs",
                        color: .blue
                    )
                    
                    StatView(
                        icon: "hand.tap.fill",
                        value: "\(viewModel.gameState.moves)",
                        label: "Moves",
                        color: .orange
                    )
                    
                    StatView(
                        icon: "star.fill",
                        value: "\(viewModel.gameState.score)",
                        label: "Score",
                        color: .yellow
                    )
                }
            }
            .padding()
            .background(Color.primary.opacity(0.05))
            .cornerRadius(20)
            .padding(.horizontal)
            
            // Game Grid
            GeometryReader { geometry in
                let gridSize = viewModel.selectedDifficulty.gridSize
                let spacing: CGFloat = 8
                let totalSpacing = CGFloat(gridSize - 1) * spacing
                let availableWidth = geometry.size.width - 40 - totalSpacing
                let tileSize = availableWidth / CGFloat(gridSize)
                
                ScrollView {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(tileSize), spacing: spacing), count: gridSize),
                        spacing: spacing
                    ) {
                        ForEach(viewModel.tiles) { tile in
                            TileView(tile: tile, size: tileSize) {
                                viewModel.tileSelected(tile)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    var timeString: String {
        let minutes = viewModel.gameState.timeRemaining / 60
        let seconds = viewModel.gameState.timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var timeColor: Color {
        if viewModel.gameState.timeRemaining > 30 {
            return .green
        } else if viewModel.gameState.timeRemaining > 10 {
            return .orange
        } else {
            return .red
        }
    }
}

struct StatView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline.bold())
                .foregroundColor(.primary)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
