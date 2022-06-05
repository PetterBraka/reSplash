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
            VGridLines(data: data, spacing: spacing, alignment: alignment)
            HGridLines(data: data, spacing: spacing, alignment: alignment)
        }
    }
}

struct VGridLines: View {
    var data: [Double]
    var spacing: CGFloat
    var alignment: Alignment
    var body: some View {
        HStack(alignment: alignment == .top ? .top : .bottom,
               spacing: spacing) {
            ForEach(data.indices, id: \.self) { index in
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 2,
                                               dash: [8]))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct VGridLine: View {
    var alignment: Alignment
    var body: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 2,
                                       dash: [8]))
            .frame(maxWidth: .infinity)
    }
}


struct HGridLines: View {
    var data: [Double]
    var spacing: CGFloat
    var alignment: Alignment
    var body: some View {
        VStack(alignment: alignment == .trailing ? .trailing : .leading,
               spacing: spacing) {
            ForEach(data.indices, id: \.self) { index in
                Line(isHorisontal: true)
                    .stroke(style: StrokeStyle(lineWidth: 2,
                                               dash: [8]))
                    .frame(maxHeight: .infinity)
            }
        }
               .padding(.horizontal, spacing)
    }
}

struct HGridLine: View {
    var alignment: Alignment
    var body: some View {
        Line(isHorisontal: true)
            .stroke(style: StrokeStyle(lineWidth: 2,
                                       dash: [8]))
            .frame(maxHeight: .infinity)
    }
}
