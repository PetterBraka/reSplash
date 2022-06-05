//
//  Alignment+Extension.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 04/06/2022.
//

import SwiftUI

public extension UnitPoint {
    init(from alignment: Alignment) {
        switch alignment {
        case .leading: self = .leading
        case .top: self = .top
        case .trailing: self = .trailing
        case .bottom: self = .bottom
        default: self = .center
        }
    }
    
    var reversed: UnitPoint {
        switch self {
        case .topLeading: return .bottomTrailing
        case .top: return .bottom
        case .topTrailing: return .bottomLeading
        case .bottomLeading: return .topTrailing
        case .bottom: return .top
        case .bottomTrailing: return .topLeading
        case .leading: return .trailing
        case .trailing: return .leading
        default: return self
        }
    }
}

public extension Edge.Set {
    init(from alignment: Alignment) {
        switch alignment {
        case .leading: self = .leading
        case .top: self = .top
        case .trailing: self = .trailing
        default: self = .bottom
        }
    }
    
    var reversed: Edge.Set {
        switch self {
        case .top: return .bottom
        case .leading: return .trailing
        case .bottom: return .top
        case .trailing: return .leading
        default: return .all
        }
    }
}
