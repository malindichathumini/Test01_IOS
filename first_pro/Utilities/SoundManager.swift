import AVFoundation
import SwiftUI
import Combine

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    @Published var isSoundEnabled: Bool = true
    
    enum SoundEffect: String {
        case flip = "flip"
        case match = "match"
        case win = "win"
        case lose = "lose"
        case click = "click"
    }
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playSound(_ sound: SoundEffect) {
        guard isSoundEnabled else { return }
        
        // Use system sounds as fallback
        switch sound {
        case .flip:
            AudioServicesPlaySystemSound(1104) // Tock sound
        case .match:
            AudioServicesPlaySystemSound(1057) // SMS Received 3
        case .win:
            AudioServicesPlaySystemSound(1025) // New Mail
        case .lose:
            AudioServicesPlaySystemSound(1006) // SMS Received 5
        case .click:
            AudioServicesPlaySystemSound(1103) // Tink
        }
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
        if isSoundEnabled {
            playSound(.click)
        }
    }
    
    func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func vibrateSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func vibrateError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}
