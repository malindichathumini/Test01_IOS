import SwiftUI

struct MenuView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            HStack {
                Button {
                    viewModel.navigateTo(.welcome)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text("Main Menu")
                    .font(.title.bold())
                
                Spacer()
                
                Button {
                    viewModel.navigateTo(.settings)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding()
            
            Spacer()
            
            // Menu Options
            VStack(spacing: 20) {
                MenuButton(
                    icon: "gamecontroller.fill",
                    title: "Quick Play",
                    subtitle: "Start with last settings",
                    gradient: [.purple, .blue]
                ) {
                    if let config = viewModel.storageManager.loadLastConfiguration() {
                        viewModel.selectedMode = config.0
                        viewModel.selectedDifficulty = config.1
                        viewModel.startNewGame()
                    } else {
                        viewModel.navigateTo(.modeSelection)
                    }
                }
                
                MenuButton(
                    icon: "sparkles",
                    title: "New Game",
                    subtitle: "Choose mode & difficulty",
                    gradient: [.orange, .red]
                ) {
                    viewModel.navigateTo(.modeSelection)
                }
                
                MenuButton(
                    icon: "trophy.fill",
                    title: "High Scores",
                    subtitle: "View your best performances",
                    gradient: [.yellow, .orange]
                ) {
                    viewModel.navigateTo(.highScores)
                }
                
                MenuButton(
                    icon: "chart.bar.fill",
                    title: "Statistics",
                    subtitle: "\(viewModel.storageManager.getGamesPlayed()) games played",
                    gradient: [.green, .mint]
                ) {
                    // Statistics view (can be added later)
                    viewModel.soundManager.playSound(.click)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct MenuButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .frame(width: 50, height: 50)
                    .background(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.primary.opacity(0.05))
            .cornerRadius(15)
        }
    }
}
