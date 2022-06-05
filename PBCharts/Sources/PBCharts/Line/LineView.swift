//
//  SwiftUIView.swift
//  
//
//  Created by Petter Vang Brakalsvalet on 05/06/2022.
//

import SwiftUI

struct LineView: View {
    var dataPoints: [Double]
    var lineWidth: CGFloat = 2
    var pointRadius: CGFloat = 8
    
    var highestPoint: Double {
        let max = dataPoints.max() ?? 1
        return max == 0 ? 1 : max + 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                getLines(with: geometry)
                getPoints(with: geometry)
            }
        }
        .animation(.easeIn, value: true)
    }
    
    func getLines(with geometry: GeometryProxy) -> some View {
        let height = geometry.size.height
        let width = geometry.size.width
        return Path { path in
            path.move(to: CGPoint(x: 0, y: height * ratio(for: 0)))
            
            for index in 1..<dataPoints.count {
                path.addLine(to: CGPoint(
                    x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                    y: height * ratio(for: index)))
            }
        }
        .stroke(Color.accentColor,
                style: StrokeStyle(lineWidth: lineWidth, lineJoin: .round))
    }
    
    func getPoints(with geometry: GeometryProxy) -> some View {
        let height = geometry.size.height
        let width = geometry.size.width
        return Path { path in
            path.move(to: CGPoint(x: 0,
                                  y: (height * ratio(for: 0)) - pointRadius))
            
            path.addArc(center: CGPoint(x: 0, y: height * ratio(for: 0)),
                        radius: pointRadius, startAngle: .zero,
                        endAngle: .degrees(360.0), clockwise: false)
            
            for index in 1..<dataPoints.count {
                path.move(to: CGPoint(
                    x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                    y: height * dataPoints[index] / highestPoint))
                
                path.addArc(center: CGPoint(
                    x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                    y: height * ratio(for: index)),
                            radius: pointRadius, startAngle: .zero,
                            endAngle: .degrees(360.0), clockwise: false)
            }
        }.fill(Color.accentColor)
    }
    
    func ratio(for index: Int) -> Double {
        1 - (dataPoints[index] / highestPoint)
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        let data: [Double] = [1, 2, 7, 3, 9, 1.4]
        VStack {
            LineView(dataPoints: data)
        }
            .padding(24)
    }
}
