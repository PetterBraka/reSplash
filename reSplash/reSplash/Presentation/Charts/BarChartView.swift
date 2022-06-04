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
                            BarView(datum: data[index],
                                    colors: colors,
                                    barSize: CGSize(width: barWidth, height: barHeight),
                                    highlightColor: highlightColor,
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
                            BarView(datum: data[index],
                                    colors: colors,
                                    barSize: CGSize(width: barWidth, height: barHeight),
                                    highlightColor: highlightColor,
                                    alignment: alignment)
                        }
                    }
                }
            }
            .padding(.leading, spacing)
        default:
            Text("Unsupported alignment")
        }
    }
}

struct BarView: View {
    @GestureState var isHolding: Bool = false
    var datum: Double
    var colors: [Color]
    var barSize: CGSize
    var cornerRadius: CGFloat = 8
    var highlightColor: Color
    var alignment: Alignment
    var reversedAlignment: UnitPoint {
        switch alignment {
        case .leading:
            return .trailing
        case .top:
            return .bottom
        case .trailing:
            return .leading
        case .bottom:
            return .top
        default:
            return .center
        }
    }
    
    var isVertical: Bool {
        alignment == .trailing || alignment == .leading
    }
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors),
                       startPoint: .init(from: alignment),
                       endPoint: reversedAlignment)
    }
    
    var body: some View {
        ZStack(alignment: alignment) {
            bar
                .frame(width: barSize.width,
                       height: barSize.height)
            if isHolding {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(highlightColor)
            }
        }
        .gesture(LongPressGesture(minimumDuration: 50,
                                  maximumDistance: barSize.width / 2)
            .updating($isHolding) { currentState, state, transaction in
                state = currentState
            }
        )
        
        .frame(width: isVertical ? nil : barSize.width,
               height: isVertical ? barSize.height : nil,
               alignment: alignment)
        .animation(.easeInOut, value: isHolding)
    }
    
    @ViewBuilder
    var bar: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(gradient)
            .opacity(datum == 0.0 ? 0.0 : 1.0)
            .frame(width: isVertical ? nil : barSize.width,
                   height: isVertical ? barSize.height : nil)
            .scaleEffect(isHolding ? 0.8 : 1, anchor: .init(from: alignment))
    }
}

struct CharView_Previews: PreviewProvider {
    static var previews: some View {
        let data: [Double] = [1, 3, 7, 2, 10]
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
