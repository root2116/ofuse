//
//  PieChartView.swift
//  Fuse
//
//  Created by araragi943 on 2023/09/27.
//

import SwiftUI


struct Segment: Identifiable {
    var id = UUID()
    var value: Double
    var color: Color
}

struct PieChartView: View {
    var segments: [Segment]
    var totalValue: Double {
            segments.reduce(0, { $0 + $1.value })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(segments) { segment in
                    PieSegment(startAngle: self.startAngle(for: segment),
                               endAngle: self.endAngle(for: segment))
                        .fill(segment.color)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func startAngle(for segment: Segment) -> Angle {
        let index = segments.firstIndex { $0.id == segment.id } ?? 0
        let precedingValue = segments.prefix(upTo: index).reduce(0, { $0 + $1.value })
        let startRadians = 2 * .pi * (precedingValue / totalValue)
        return Angle(radians: startRadians)
        
    }
    
    private func endAngle(for segment: Segment) -> Angle {
        // Calculate the end angle for the segment
        let startRadians = startAngle(for: segment).radians
                let segmentRadians = 2 * .pi * (segment.value / totalValue)
                return Angle(radians: startRadians + segmentRadians)
    }
}

struct PieSegment: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}
