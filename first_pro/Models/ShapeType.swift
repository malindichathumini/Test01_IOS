import SwiftUI

enum ShapeType: String, Codable, CaseIterable {
    case circle, square, triangle, diamond, pentagon, hexagon, star, heart
    
    var name: String {
        rawValue.capitalized
    }
    
    @ViewBuilder
    func shape(size: CGFloat) -> some View {
        switch self {
        case .circle:
            Circle()
                .frame(width: size, height: size)
        case .square:
            Rectangle()
                .frame(width: size, height: size)
        case .triangle:
            TriangleShape()
                .frame(width: size, height: size)
        case .diamond:
            DiamondShape()
                .frame(width: size, height: size)
        case .pentagon:
            PentagonShape()
                .frame(width: size, height: size)
        case .hexagon:
            HexagonShape()
                .frame(width: size, height: size)
        case .star:
            StarShape()
                .frame(width: size, height: size)
        case .heart:
            HeartShape()
                .frame(width: size, height: size)
        }
    }
}

// Custom Shape Implementations
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct PentagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angle = -CGFloat.pi / 2
        
        for i in 0..<5 {
            let x = center.x + radius * cos(angle + CGFloat(i) * 2 * .pi / 5)
            let y = center.y + radius * sin(angle + CGFloat(i) * 2 * .pi / 5)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angle = -CGFloat.pi / 2
        
        for i in 0..<6 {
            let x = center.x + radius * cos(angle + CGFloat(i) * 2 * .pi / 6)
            let y = center.y + radius * sin(angle + CGFloat(i) * 2 * .pi / 6)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let angle = -CGFloat.pi / 2
        
        for i in 0..<10 {
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + radius * cos(angle + CGFloat(i) * .pi / 5)
            let y = center.y + radius * sin(angle + CGFloat(i) * .pi / 5)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width/2, y: height))
        
        path.addCurve(
            to: CGPoint(x: 0, y: height/4),
            control1: CGPoint(x: width/2, y: height*3/4),
            control2: CGPoint(x: 0, y: height/2)
        )
        
        path.addArc(
            center: CGPoint(x: width/4, y: height/4),
            radius: width/4,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        path.addArc(
            center: CGPoint(x: width*3/4, y: height/4),
            radius: width/4,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        path.addCurve(
            to: CGPoint(x: width/2, y: height),
            control1: CGPoint(x: width, y: height/2),
            control2: CGPoint(x: width/2, y: height*3/4)
        )
        
        return path
    }
}
