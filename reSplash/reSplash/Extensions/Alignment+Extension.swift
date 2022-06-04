//
//  Alignment+Extension.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 04/06/2022.
//

import SwiftUI

extension UnitPoint {
    init(from alignimnet: Alignment) {
        switch alignimnet {
        case .leading:
            self = .leading
        case .top:
            self = .top
        case .trailing:
            self = .trailing
        case .bottom:
            self = .bottom
        default:
            self = .center
        }
    }
}
