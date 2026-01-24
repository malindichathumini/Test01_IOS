import SwiftUI

struct GameModeSelectionView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 30) {
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
                
                Text("Choose Game Mode")
                    .font(.title2.bold())
                
                Spacer()
                
                Color.clear
                    .frame(width: 30)
            }
            .padding()
            
            // Mode Cards
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(GameMode.allCases, id: \.self) { mode in
                        ModeCard(mode: mode, isSelected: viewModel.selectedMode == mode) {
                            viewModel.selectedMode = mode
                            viewModel.soundManager.playSound(.click)
                            viewModel.navigateTo(.difficultySelection)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ModeCard: View {
    let mode: GameMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(mode.icon)
                        .font(.system(size: 50))
                    
                    Spacer()
                    
                    Text(mode.difficulty)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(difficultyColor.opacity(0.2))
                        .foregroundColor(difficultyColor)
                        .cornerRadius(8)
                }
                
                Text(mode.rawValue)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text(mode.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Example preview
                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(exampleGradient)
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
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
    
    var difficultyColor: Color {
        switch mode.difficulty {
        case "Easy": return .green
        case "Medium": return .orange
        case "Hard": return .red
        default: return .blue
        }
    }
    
    var exampleGradient: LinearGradient {
        LinearGradient(
            colors: [.purple, .blue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
