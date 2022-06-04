//
//  WorkoutCellView.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 04/06/2022.
//

import SwiftUI

struct WorkoutCellView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Workout title - date")
            Text("Distance, Duration, avg speed")
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.opacity(0.2))
        )
    }
}

struct WorkoutCellView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCellView()
    }
}
