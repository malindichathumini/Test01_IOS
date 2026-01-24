import Foundation

enum GameDifficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case complex = "Complex"
    
    var gridSize: Int {
        switch self {
        case .easy: return 3      // 3x3 = 9 tiles
        case .medium: return 5    // 5x5 = 25 tiles
        case .complex: return 7   // 7x7 = 49 tiles
        }
    }
    
    var pairsCount: Int {
        switch self {
        case .easy: return 4      // 8 tiles (4 pairs)
        case .medium: return 12   // 24 tiles (12 pairs)
        case .complex: return 24  // 48 tiles (24 pairs)
        }
    }
    
    var timeLimit: Int {
        switch self {
        case .easy: return 60     // 60 seconds
        case .medium: return 90   // 90 seconds
        case .complex: return 120 // 120 seconds
        }
    }
    
    var description: String {
        switch self {
        case .easy:
            return "3x3 grid • 4 pairs • 60 seconds"
        case .medium:
            return "5x5 grid • 12 pairs • 90 seconds"
        case .complex:
            return "7x7 grid • 24 pairs • 120 seconds"
        }
    }
    
    var icon: String {
        switch self {
        case .easy: return "⭐"
        case .medium: return "⭐⭐"
        case .complex: return "⭐⭐⭐"
        }
    }
}
