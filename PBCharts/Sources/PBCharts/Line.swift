//
//  SwiftUIView.swift
//  
//
//  Created by Petter Vang Brakalsvalet on 05/06/2022.
//

import SwiftUI

struct Line: Shape {
    var isHorisontal: Bool = false
    
    func path(in rect: CGRect) -> Path {
        var start: CGPoint
        var end: CGPoint
        if isHorisontal {
            start = CGPoint(x: rect.minX, y: rect.midY)
            end = CGPoint(x: rect.maxX, y: rect.midY)
        } else {
            start = CGPoint(x: rect.midX, y: rect.minY)
            end = CGPoint(x: rect.midX, y: rect.maxY)
        }
        
        return Path { p in
            p.move(to: start)
            p.addLine(to: end)
        }
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        Line()
    }
}
