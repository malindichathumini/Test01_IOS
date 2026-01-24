import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var showConfetti = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Result Icon
            Text(viewModel.gameState.isWon ? "🎉" : "😢")
                .font(.system(size: 100))
                .scaleEffect(showConfetti ? 1.2 : 1.0)
                .animation(
                    Animation.spring(response: 0.5, dampingFraction: 0.6).repeatCount(3),
                    value: showConfetti
                )
            
            // Result Title
            Text(viewModel.gameState.isWon ? "Victory!" : "Time's Up!")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: viewModel.gameState.isWon ? [.green, .blue] : [.red, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            // Stats Card
            VStack(spacing: 20) {
                // Final Score
                VStack(spacing: 5) {
                    Text("Final Score")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(viewModel.gameState.score)")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.yellow.opacity(0.2))
                )
                
                // Other Stats
                HStack(spacing: 15) {
                    ResultStatView(
                        icon: "target",
                        label: "Matches",
                        value: "\(viewModel.gameState.matchedPairs)/\(viewModel.gameState.totalPairs)"
                    )
                    
                    ResultStatView(
                        icon: "hand.tap.fill",
                        label: "Moves",
                        value: "\(viewModel.gameState.moves)"
                    )
                    
                    ResultStatView(
                        icon: "clock.fill",
                        label: "Time Left",
                        value: "\(viewModel.gameState.timeRemaining)s"
                    )
                }
                
                // High Score Indicator
                if viewModel.gameState.isWon {
                    if let topScore = viewModel.highScoreManager.getTopScore(
                        for: viewModel.selectedMode,
                        difficulty: viewModel.selectedDifficulty
                    ), viewModel.gameState.score >= topScore {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            Text("New High Score!")
                                .font(.headline.bold())
                                .foregroundColor(.yellow)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.yellow.opacity(0.2))
                        )
                    }
                }
            }
            .padding()
            .background(Color.primary.opacity(0.05))
            .cornerRadius(20)
            .padding(.horizontal)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 15) {
                Button {
                    viewModel.restartGame()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Play Again")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
                
                HStack(spacing: 15) {
                    Button {
                        viewModel.navigateTo(.highScores)
                    } label: {
                        HStack {
                            Image(systemName: "trophy.fill")
                            Text("High Scores")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(15)
                    }
                    
                    Button {
                        viewModel.navigateTo(.menu)
                    } label: {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("Menu")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            showConfetti = true
        }
    }
}

struct ResultStatView: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title3.bold())
                .foregroundColor(.primary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.primary.opacity(0.05))
        .cornerRadius(12)
    }
}
