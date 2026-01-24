import SwiftUI

struct TileView: View {
    let tile: GameTile
    let size: CGFloat
    let onTap: () -> Void
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Back of card
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(tile.isFlipped || tile.isMatched ? 0 : 1)
                
                // Front of card
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(tile.isMatched ? Color.green.opacity(0.3) : Color.white)
                    
                    if tile.isFlipped || tile.isMatched {
                        // Fixed: Create shape view properly
                        Group {
                            switch tile.shape {
                            case .circle:
                                Circle()
                                    .fill(tile.color)
                            case .square:
                                Rectangle()
                                    .fill(tile.color)
                            case .triangle:
                                TriangleShape()
                                    .fill(tile.color)
                            case .diamond:
                                DiamondShape()
                                    .fill(tile.color)
                            case .pentagon:
                                PentagonShape()
                                    .fill(tile.color)
                            case .hexagon:
                                HexagonShape()
                                    .fill(tile.color)
                            case .star:
                                StarShape()
                                    .fill(tile.color)
                            case .heart:
                                HeartShape()
                                    .fill(tile.color)
                            }
                        }
                        .frame(width: size * 0.6, height: size * 0.6)
                        .opacity(tile.isMatched ? 0.5 : 1)
                    }
                }
                .opacity(tile.isFlipped || tile.isMatched ? 1 : 0)
                .rotation3DEffect(
                    .degrees(tile.isFlipped || tile.isMatched ? 0 : 180),
                    axis: (x: 0, y: 1, z: 0)
                )
            }
            .frame(width: size, height: size)
            .rotation3DEffect(
                .degrees(tile.isFlipped || tile.isMatched ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .scaleEffect(tile.isMatched ? 0.9 : 1.0)
            .animation(
                viewModel.settings.animationsEnabled ?
                    .spring(response: 0.6, dampingFraction: 0.7) : .none,
                value: tile.isFlipped
            )
            .animation(
                viewModel.settings.animationsEnabled ?
                    .spring(response: 0.4, dampingFraction: 0.6) : .none,
                value: tile.isMatched
            )
        }
        .disabled(tile.isFlipped || tile.isMatched)
    }
}
