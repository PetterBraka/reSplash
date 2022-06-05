//
//  ContentView.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 03/06/2022.
//

import SwiftUI

struct ContentView: View {
    let data: [Double] = [1, 3, 7, 2, 10, 2]
    let spacing: CGFloat = 24
    var body: some View {
        VStack {
            WorkoutCellView()
        }.foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
