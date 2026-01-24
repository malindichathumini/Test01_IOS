import SwiftUI

struct GameTile: Identifiable, Equatable {
    let id = UUID()
    let shape: ShapeType
    let color: Color
    var isFlipped: Bool = false
    var isMatched: Bool = false
    let pairId: Int
    
    // Matching logic based on game mode
    func matches(_ other: GameTile, mode: GameMode) -> Bool {
        guard pairId == other.pairId else { return false }
        
        switch mode {
        case .colorMatch:
            return color == other.color
        case .shapeMatch:
            return shape == other.shape
        case .comboMatch:
            return color == other.color && shape == other.shape
        }
    }
    
    static func == (lhs: GameTile, rhs: GameTile) -> Bool {
        lhs.id == rhs.id
    }
}
