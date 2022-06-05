//
//  BarView.swift
//  
//
//  Created by Petter Vang Brakalsvalet on 05/06/2022.
//

import SwiftUI

internal struct BarView: View {
    @GestureState var isHolding: Bool = false
    var datum: Double
    var colors: [Color]?
    var barLength: CGFloat
    var cornerRadius: CGFloat = 8
    var highlightColor: Color
    var alignment: Alignment
    
    var reversedAlignment: UnitPoint { .init(from: alignment).reversed }
    var isVertical: Bool { alignment == .top || alignment == .bottom }
    var gradient: LinearGradient? {
        if let colors = colors {
            return LinearGradient(gradient: Gradient(colors: colors),
                                  startPoint: .init(from: alignment),
                                  endPoint: reversedAlignment)
        } else {
            return nil
        }
    }
    
    var body: some View {
        ZStack(alignment: alignment) {
            bar
                .frame(width: isVertical ? nil : barLength,
                       height: isVertical ? barLength : nil,
                       alignment: alignment)
            if isHolding {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(highlightColor)
            }
        }
        .gesture(LongPressGesture(minimumDuration: 50)
            .updating($isHolding) { currentState, state, transaction in
                state = currentState
            }
        )
        .animation(.easeInOut, value: isHolding)
    }
    
    @ViewBuilder
    var bar: some View {
        if let gradient = gradient {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(gradient)
                .opacity(datum == 0.0 ? 0.0 : 1.0)
                .scaleEffect(isHolding ? 0.8 : 1, anchor: .init(from: alignment))
        } else {
            RoundedRectangle(cornerRadius: cornerRadius)
                .opacity(datum == 0.0 ? 0.0 : 1.0)
                .scaleEffect(isHolding ? 0.8 : 1, anchor: .init(from: alignment))
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        let data: [Double] = [1, 2, 7, 3, 10, 1.4]
        let colors: [Color] = [.blue, .yellow]
        VStack {
            BarChartView(data: data,
                         alignment: .leading)
//            BarChartView(data: data,
//                         alignment: .trailing)
//            BarChartView(data: data,
//                         colors: colors,
//                         alignment: .bottom)
//            BarChartView(data: data,
//                         alignment: .top)
        }
        .foregroundColor(.red)
        .padding(16)
    }
}
