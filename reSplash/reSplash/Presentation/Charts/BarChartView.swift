//
//  BarChartView.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 04/06/2022.
//

import SwiftUI

struct BarChartView: View {
    var data: [Double]
    var colors: [Color]
    var spacing: CGFloat
    var alignment: Alignment
    var highlightColor: Color = .black
    var minBarWith: CGFloat = 2
    
    var highestData: Double {
        let max = data.max() ?? 1
        return max == 0 ? 1 : max
    }
    
    var body: some View {
        switch alignment {
        case .leading, .trailing:
            GeometryReader { geometry in
                let frameWidth = geometry.size.width
                let frameHeight = geometry.size.height
                VStack(alignment: alignment == .leading ? .leading : .trailing,
                       spacing: spacing) {
                    let barHeight = (frameHeight / CGFloat(data.count)) - spacing
                    
                    if barHeight < minBarWith {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Not enough space to display graph")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        Spacer()
                    } else {
                        ForEach(data.indices, id: \.self) { index in
                            let barWidth = frameWidth * data[index] / highestData
                            BarView(datum: data[index], colors: colors)
                                .highlight(with: highlightColor,
                                           alignment: alignment)
                                .frame(width: barWidth,
                                       height: barHeight,
                                       alignment: alignment)
                        }
                    }
                }
            }.padding(.top, spacing)
        case .top, .bottom:
            GeometryReader { geometry in
                let frameWidth = geometry.size.width
                let frameHeight = geometry.size.height
                HStack(alignment: alignment == .bottom ? .bottom : .top,
                       spacing: spacing) {
                    let barWidth = (frameWidth / CGFloat(data.count)) - spacing
                    
                    if barWidth < minBarWith {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Not enough space to display graph")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        Spacer()
                    } else {
                    ForEach(data.indices, id: \.self) { index in
                        let barHeight = frameHeight * data[index] / highestData
                        
                        BarView(datum: data[index], colors: colors)
                            .highlight(with: highlightColor,
                                       alignment: alignment)
                            .frame(width: barWidth,
                                   height: barHeight,
                                   alignment: alignment)
                    }
                    }
                }
            }.padding(.leading, spacing)
        default:
            Text("Unsupported alignment")
        }
    }
}

struct BarView: View {
    var datum: Double
    var colors: [Color]
    var cornerRadius: CGFloat = 8
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors),
                       startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(gradient)
            .opacity(datum == 0.0 ? 0.0 : 1.0)
    }
    
    func highlight(with color: Color, alignment: Alignment) -> some View {
        switch alignment {
        case .leading:
            return self.modifier(HighlightBar(alignment: .leading,
                                              highlightColor: color,
                                              cornerRadius: cornerRadius))
        case .trailing:
            return self.modifier(HighlightBar(alignment: .trailing,
                                              highlightColor: color,
                                              cornerRadius: cornerRadius))
        case .top:
            return self.modifier(HighlightBar(alignment: .top,
                                              highlightColor: color,
                                              cornerRadius: cornerRadius))
        case .bottom:
            return self.modifier(HighlightBar(alignment: .bottom,
                                              highlightColor: color,
                                              cornerRadius: cornerRadius))
        default:
            return self.modifier(HighlightBar(alignment: .center,
                                              highlightColor: color,
                                              cornerRadius: cornerRadius))
        }
    }
    
    struct HighlightBar: ViewModifier {
        @GestureState var isHolding: Bool = false
        var alignment: UnitPoint
        var highlightColor: Color
        var cornerRadius: CGFloat
        
        func body(content: Content) -> some View {
            GeometryReader { proxy in
                let isVertical = alignment == .top || alignment == .bottom
                let barWidth = isVertical ? proxy.size.width : proxy.size.height
                ZStack {
                    content
                        .scaleEffect(isHolding ? 0.5 : 1, anchor: alignment)
                        .gesture(LongPressGesture(minimumDuration: 50,
                                                  maximumDistance: barWidth / 2)
                            .updating($isHolding) { currentState, state, transaction in
                                state = currentState
                            }
                        )
                    if isHolding {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(highlightColor)
                    }
                }
                .animation(.easeInOut, value: isHolding)
            }
        }
    }
}

struct CharView_Previews: PreviewProvider {
    static var previews: some View {
        let data: [Double] = [1, 2, 7, 8, 2, 4, 10]
        let colors: [Color] = [.blue]
        let spacing: CGFloat = 8
        VStack {
            BarChartView(data: data,
                         colors: colors,
                         spacing: spacing,
                         alignment: .leading)
            BarChartView(data: data,
                         colors: colors,
                         spacing: spacing,
                         alignment: .trailing)
            BarChartView(data: data,
                         colors: colors,
                         spacing: spacing,
                         alignment: .bottom)
            BarChartView(data: data,
                         colors: colors,
                         spacing: spacing,
                         alignment: .top)
        }
        .padding(16)
    }
}
