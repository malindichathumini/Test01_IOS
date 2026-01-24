import SwiftUI

struct HighScoresView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var selectedMode: GameMode = .colorMatch
    @State private var selectedDifficulty: GameDifficulty = .easy
    @State private var showClearAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button {
                    viewModel.navigateTo(.menu)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack {
                    Text("🏆 High Scores")
                        .font(.title.bold())
                    
                    Text("\(viewModel.storageManager.getGamesPlayed()) Games Played")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    showClearAlert = true
                } label: {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
            .padding()
            
            // Filters
            VStack(spacing: 15) {
                // Mode Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(GameMode.allCases, id: \.self) { mode in
                            Button {
                                selectedMode = mode
                                viewModel.soundManager.playSound(.click)
                            } label: {
                                HStack {
                                    Text(mode.icon)
                                    Text(mode.rawValue)
                                        .font(.subheadline.bold())
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(
                                    selectedMode == mode ?
                                        Color.blue : Color.primary.opacity(0.1)
                                )
                                .foregroundColor(selectedMode == mode ? .white : .primary)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Difficulty Selector
                HStack(spacing: 10) {
                    ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                        Button {
                            selectedDifficulty = difficulty
                            viewModel.soundManager.playSound(.click)
                        } label: {
                            VStack(spacing: 4) {
                                Text(difficulty.icon)
                                    .font(.title3)
                                Text(difficulty.rawValue)
                                    .font(.caption.bold())
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedDifficulty == difficulty ?
                                    Color.purple : Color.primary.opacity(0.1)
                            )
                            .foregroundColor(selectedDifficulty == difficulty ? .white : .primary)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Scores List
            let scores = viewModel.highScoreManager.getScores(
                for: selectedMode,
                difficulty: selectedDifficulty
            )
            
            if scores.isEmpty {
                Spacer()
                
                VStack(spacing: 15) {
                    Image(systemName: "trophy.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("No Scores Yet")
                        .font(.title2.bold())
                        .foregroundColor(.secondary)
                    
                    Text("Play this mode to set your first score!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(scores.enumerated()), id: \.element.id) { index, score in
                            HighScoreRow(score: score, rank: index + 1)
                        }
                    }
                    .padding()
                }
            }
        }
        .alert("Clear All Scores?", isPresented: $showClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.resetAllData()
            }
        } message: {
            Text("This will delete all high scores and statistics. This action cannot be undone.")
        }
    }
}

struct HighScoreRow: View {
    let score: HighScore
    let rank: Int
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank
            Text("\(rank)")
                .font(.title2.bold())
                .foregroundColor(rankColor)
                .frame(width: 40)
            
            // Details
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(score.score)")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(dateString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 15) {
                    Label("\(score.moves)", systemImage: "hand.tap.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("\(score.timeRemaining)s", systemImage: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Medal
            if rank <= 3 {
                Image(systemName: medalIcon)
                    .font(.title)
                    .foregroundColor(rankColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(rank <= 3 ? rankColor.opacity(0.1) : Color.primary.opacity(0.05))
        )
    }
    
    var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .blue
        }
    }
    
    var medalIcon: String {
        switch rank {
        case 1: return "medal.fill"
        case 2: return "medal.fill"
        case 3: return "medal.fill"
        default: return ""
        }
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: score.date)
    }
}
