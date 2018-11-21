//
//  RootAssembly.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
