//
//  ManagerAssembly.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 03/06/2022.
//

import Swinject

class ManagerAssembly: Assembly {
    func assemble(container: Container) {
        // PersistenceController
        container.register(PersistenceControllerProtocol.self) { _ in
            PersistenceController()
        }.inObjectScope(.container)
    }
}
