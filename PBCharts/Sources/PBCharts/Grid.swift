//
//  Grid.swift
//  
//
//  Created by Petter Vang Brakalsvalet on 05/06/2022.
//

import SwiftUI

struct Grid: View {
    var data: [Double]
    var spacing: CGFloat
    var alignment: Alignment
    var body: some View {
        ZStack {
            vGrid
            hGrid
        }
    }
    
    @ViewBuilder
    var vGrid: some View {
        HStack(alignment: alignment == .bottom ? .bottom : .top,
               spacing: spacing) {
            ForEach(data.indices, id: \.self) { index in
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 2,
                                               dash: [8]))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    @ViewBuilder
    var hGrid: some View {
        VStack(alignment: alignment == .leading ? .leading : .trailing,
               spacing: spacing) {
            ForEach(data.indices, id: \.self) { index in
                Line(isHorisontal: true)
                    .stroke(style: StrokeStyle(lineWidth: 2,
                                               dash: [8]))
                    .frame(maxHeight: .infinity)
            }
        }
    }
}
