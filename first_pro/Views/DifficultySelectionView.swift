import SwiftUI

struct DifficultySelectionView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            HStack {
                Button {
                    viewModel.navigateTo(.modeSelection)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack {
                    Text("Choose Difficulty")
                        .font(.title2.bold())
                    Text(viewModel.selectedMode.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Color.clear
                    .frame(width: 30)
            }
            .padding()
            
            // Difficulty Cards
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                        DifficultyCard(
                            difficulty: difficulty,
                            isSelected: viewModel.selectedDifficulty == difficulty,
                            viewModel: viewModel
                        ) {
                            viewModel.selectedDifficulty = difficulty
                            viewModel.soundManager.playSound(.click)
                        }
                    }
                }
                .padding()
            }
            
            // Start Button
            Button {
                viewModel.startNewGame()
            } label: {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Game")
                        .font(.title3.bold())
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
                .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding()
        }
    }
}

struct DifficultyCard: View {
    let difficulty: GameDifficulty
    let isSelected: Bool
    let viewModel: GameViewModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                HStack {
                    Text(difficulty.icon)
                        .font(.system(size: 40))
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(difficulty.rawValue)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Text(difficulty.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // High Score
                    if let topScore = viewModel.highScoreManager.getTopScore(
                        for: viewModel.selectedMode,
                        difficulty: difficulty
                    ) {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.orange)
                            Text("Best: \(topScore)")
                                .font(.caption.bold())
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.primary.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                    )
            )
        }
    }
}
