//
//  MainAssembler.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 03/06/2022.
//

import Swinject

class MainAssembler {
    public static let shared = MainAssembler()

    private let container: Container
    private let assembler: Assembler

    private init() {
        container = Container()
        assembler = Assembler([],
                              container: container)
    }

    public static func resolve<T>() -> T {
        guard let object = shared.container.resolve(T.self) else {
            fatalError("Failed resolving \(T.self)")
        }
        return object
    }
}
