import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var showResetAlert = false
    
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
                
                Text("⚙️ Settings")
                    .font(.title.bold())
                
                Spacer()
                
                Color.clear
                    .frame(width: 30)
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Audio Settings
                    SettingsSection(title: "Audio") {
                        ToggleRow(
                            icon: "speaker.wave.3.fill",
                            title: "Sound Effects",
                            isOn: viewModel.settings.soundEnabled
                        ) {
                            viewModel.toggleSound()
                        }
                    }
                    
                    // Visual Settings
                    SettingsSection(title: "Visual") {
                        ToggleRow(
                            icon: "sparkles",
                            title: "Animations",
                            isOn: viewModel.settings.animationsEnabled
                        ) {
                            viewModel.toggleAnimations()
                        }
                        
                        Divider()
                        
                        // Theme Selector
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "paintbrush.fill")
                                    .foregroundColor(.blue)
                                Text("Theme")
                                    .font(.headline)
                            }
                            
                            HStack(spacing: 10) {
                                ForEach(GameSettings.Theme.allCases, id: \.self) { theme in
                                    Button {
                                        viewModel.changeTheme(theme)
                                    } label: {
                                        Text(theme.rawValue)
                                            .font(.subheadline.bold())
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(
                                                viewModel.settings.theme == theme ?
                                                    Color.blue : Color.primary.opacity(0.1)
                                            )
                                            .foregroundColor(
                                                viewModel.settings.theme == theme ?
                                                    .white : .primary
                                            )
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Statistics
                    SettingsSection(title: "Statistics") {
                        StatRow(
                            icon: "gamecontroller.fill",
                            title: "Games Played",
                            value: "\(viewModel.storageManager.getGamesPlayed())",
                            color: .blue
                        )
                        
                        Divider()
                        
                        StatRow(
                            icon: "star.fill",
                            title: "Total Score",
                            value: "\(viewModel.storageManager.getTotalScore())",
                            color: .yellow
                        )
                        
                        Divider()
                        
                        StatRow(
                            icon: "trophy.fill",
                            title: "High Scores",
                            value: "\(viewModel.highScoreManager.scores.count)",
                            color: .orange
                        )
                    }
                    
                    // About
                    SettingsSection(title: "About") {
                        InfoRow(title: "Version", value: "1.0.0")
                        
                        Divider()
                        
                        InfoRow(title: "Developer", value: "Memory Match Pro")
                    }
                    
                    // Danger Zone
                    VStack(spacing: 15) {
                        Button {
                            showResetAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Reset All Data")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(15)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
        }
        .alert("Reset All Data?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                viewModel.resetAllData()
            }
        } message: {
            Text("This will delete all high scores, statistics, and settings. This action cannot be undone.")
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.primary)
            
            VStack(spacing: 15) {
                content
            }
            .padding()
            .background(Color.primary.opacity(0.05))
            .cornerRadius(15)
        }
    }
}

struct ToggleRow: View {
    let icon: String
    let title: String
    let isOn: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: .constant(isOn))
                    .labelsHidden()
                    .allowsHitTesting(false)
            }
        }
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.headline.bold())
                .foregroundColor(color)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}
