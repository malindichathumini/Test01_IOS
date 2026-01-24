import Foundation

enum GameMode: String, Codable, CaseIterable {
    case colorMatch = "Color Match"
    case shapeMatch = "Shape Match"
    case comboMatch = "Combo Match"
    
    var description: String {
        switch self {
        case .colorMatch:
            return "Match tiles by color only"
        case .shapeMatch:
            return "Match tiles by shape only"
        case .comboMatch:
            return "Match both color AND shape"
        }
    }
    
    var icon: String {
        switch self {
        case .colorMatch:
            return "🎨"
        case .shapeMatch:
            return "⬛"
        case .comboMatch:
            return "🎯"
        }
    }
    
    var difficulty: String {
        switch self {
        case .colorMatch:
            return "Easy"
        case .shapeMatch:
            return "Medium"
        case .comboMatch:
            return "Hard"
        }
    }
}
