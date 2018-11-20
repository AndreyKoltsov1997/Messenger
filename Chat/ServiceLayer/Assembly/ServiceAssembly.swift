//
//  ServiceAssembly.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    func communicationService(displayingName name: String) -> ICommunicationService
    func storageManagerService() -> IStorageManagerService
    func gcdDataManager() -> GCDDataManager
}

class ServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
}

// MARK: - IServicesAssembly

extension ServicesAssembly: IServicesAssembly {
    func gcdDataManager() -> GCDDataManager {
        return self.coreAssembly.gcdDataManager
    }
    
    func storageManagerService() -> IStorageManagerService {
        return self.coreAssembly.coreDataStorage
    }
    
    func communicationService(displayingName name: String) -> ICommunicationService {
        return CommunicationService(displayingName: name)
    }
    
}
