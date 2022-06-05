//
//  DragGesture+Extension.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 05/06/2022.
//

import SwiftUI

public extension DragGesture.Value {
    enum SwipeDirection: String {
        case left, right, up, down, none
    }
    
    var swipeDirection: SwipeDirection {
        if startLocation.x > location.x {
            return .left
        }
        if startLocation.x < location.x {
            return .right
        }
        if startLocation.y > location.y {
            return .down
        }
        if startLocation.y < location.y {
            return .up
        }
        return .none
    }
}
