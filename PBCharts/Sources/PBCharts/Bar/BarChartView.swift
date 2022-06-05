//
//  BarChartView.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 04/06/2022.
//

import SwiftUI

public struct BarChartView: View {
    var data: [Double]
    var colors: [Color]?
    var spacing: CGFloat
    var cornerRadius: CGFloat
    var alignment: Alignment
    var highlightColor: Color = .black
    var gridColor: Color = .black.opacity(0.2)
    var minBarWith: CGFloat = 2
    
    var showGrid: Bool = true
    
    var reversedAlignment: Edge.Set { .init(from: alignment).reversed }
    
    var highestData: Double {
        let max = data.max() ?? 1
        return max == 0 ? 1 : max + 1
    }
    
    public init(data: [Double],
                colors: [Color]? = nil,
                spacing: CGFloat = 16,
                cornerRadius: CGFloat = 8,
                alignment: Alignment,
                highlightColor: Color = .black,
                minBarWith: CGFloat = 2) {
        self.data = data
        self.colors = colors
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.alignment = alignment
        self.highlightColor = highlightColor
        self.minBarWith = minBarWith
    }
    
    public init(){
        self.data = [1, 3.4, 2, 9, 7]
        self.colors = nil
        self.spacing = 8
        self.cornerRadius = 8
        self.alignment = .bottom
        self.highlightColor = .red
        self.minBarWith = 2
    }
    
    public var body: some View {
        switch alignment {
        case .leading, .trailing:
            vertiaclAlignedBars
        case .top, .bottom:
            horisontalAlignedBars
        default:
            Text("Unsupported alignment")
        }
    }
    
    @ViewBuilder
    var vertiaclAlignedBars: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = geometry.size.height
            VStack(alignment: alignment == .leading ? .leading : .trailing,
                   spacing: spacing) {
                if minBarWith < (frameWidth / CGFloat(data.count) - spacing) {
                    ForEach(data.indices, id: \.self) { index in
                        let dataPoint = data[index]
                        let barWidth = frameWidth * dataPoint / highestData
                        ZStack(alignment: alignment) {
                            if showGrid {
                                HGridLine(alignment: alignment)
                                    .foregroundColor(gridColor)
                            }
                            BarView(datum: dataPoint,
                                    colors: colors,
                                    barLength: barWidth,
                                    cornerRadius: cornerRadius,
                                    highlightColor: highlightColor,
                                    alignment: alignment)
                        }
                    }
                } else {
                    spacingError
                }
            }
                .frame(width: frameWidth, height: frameHeight)
                .background(
                    HStack(spacing: 0) {
                        let highestValue = Int(highestData.rounded(.up)) /  2
                        let numbersOfLines = Int(frameWidth) / 20 / highestValue
                        ForEach(0...numbersOfLines, id: \.self) { index in
                            if showGrid {
                                VGridLine(alignment: alignment)
                                    .foregroundColor(gridColor)
                            }
                        }
                    }
                )
        }
    }
    
    @ViewBuilder
    var horisontalAlignedBars: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = geometry.size.height
            HStack(alignment: alignment == .bottom ? .bottom : .top,
                   spacing: spacing) {
                if minBarWith < (frameWidth / CGFloat(data.count) - spacing) {
                    ForEach(data.indices, id: \.self) { index in
                        let dataPoint = data[index]
                        let barHeight = frameHeight * dataPoint / highestData
                        ZStack(alignment: alignment) {
                            if showGrid {
                                VGridLine(alignment: alignment)
                                    .foregroundColor(gridColor)
                            }
                            BarView(datum: dataPoint,
                                    colors: colors,
                                    barLength: barHeight,
                                    cornerRadius: cornerRadius,
                                    highlightColor: highlightColor,
                                    alignment: alignment)
                        }
                    }
                } else {
                    spacingError
                }
            }
                .frame(width: frameWidth, height: frameHeight)
                .background(
                    VStack(spacing: 0) {
                        let highestValue = Int(highestData.rounded(.up)) /  2
                        let numbersOfLines = Int(frameHeight) / 20 / highestValue
                        ForEach(0...numbersOfLines, id: \.self) { index in
                            if showGrid {
                                HGridLine(alignment: alignment)
                                    .foregroundColor(gridColor)
                            }
                        }
                    }
                )
        }
    }
    
    @ViewBuilder
    var spacingError: some View {
        Text("Not enough space to desplay graph")
            .font(.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CharView_Previews: PreviewProvider {
    static var previews: some View {
        let data: [Double] = [1, 2.789, 2, 2, 10, 4]
        VStack {
            BarChartView(data: data,
                         alignment: .leading)
            BarChartView(data: data,
                         alignment: .trailing)
            BarChartView(data: data,
                         alignment: .top)
            BarChartView(data: data,
                         alignment: .bottom)
        }
        .foregroundColor(.blue)
    }
}
