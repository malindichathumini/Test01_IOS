import SwiftUI

struct ColorPalette {
    static let colors: [Color] = [
        // Vibrant colors
        Color(hex: "FF6B6B"), // Red
        Color(hex: "4ECDC4"), // Turquoise
        Color(hex: "45B7D1"), // Blue
        Color(hex: "FFA07A"), // Light Salmon
        Color(hex: "98D8C8"), // Mint
        Color(hex: "F7DC6F"), // Yellow
        Color(hex: "BB8FCE"), // Purple
        Color(hex: "85C1E2"), // Sky Blue
        Color(hex: "F8B88B"), // Peach
        Color(hex: "B8E994"), // Light Green
        
        // Rich colors
        Color(hex: "E74C3C"), // Crimson
        Color(hex: "3498DB"), // Dodger Blue
        Color(hex: "2ECC71"), // Emerald
        Color(hex: "F39C12"), // Orange
        Color(hex: "9B59B6"), // Amethyst
        Color(hex: "1ABC9C"), // Turquoise Green
        Color(hex: "E67E22"), // Carrot
        Color(hex: "34495E"), // Wet Asphalt
        Color(hex: "16A085"), // Green Sea
        Color(hex: "C0392B"), // Pomegranate
        
        // Pastel colors
        Color(hex: "FFB6C1"), // Light Pink
        Color(hex: "DDA0DD"), // Plum
        Color(hex: "87CEEB"), // Sky Blue Light
        Color(hex: "98FB98"), // Pale Green
        Color(hex: "F0E68C"), // Khaki
    ]
    
    static func randomColor() -> Color {
        colors.randomElement() ?? .blue
    }
    
    static func getColors(count: Int) -> [Color] {
        var selectedColors: [Color] = []
        var availableColors = colors
        
        for _ in 0..<min(count, colors.count) {
            if let color = availableColors.randomElement(),
               let index = availableColors.firstIndex(of: color) {
                selectedColors.append(color)
                availableColors.remove(at: index)
            }
        }
        
        return selectedColors
    }
}

// Color extension for hex support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
