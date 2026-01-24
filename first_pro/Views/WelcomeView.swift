import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Game Title
            VStack(spacing: 10) {
                Text("🎮")
                    .font(.system(size: 80))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Text("Memory Match Pro")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Train Your Brain")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Buttons
            VStack(spacing: 20) {
                Button {
                    viewModel.navigateTo(.menu)
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
                        viewModel.navigateTo(.settings)
                    } label: {
                        HStack {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .padding()
        .onAppear {
            isAnimating = true
        }
    }
}
