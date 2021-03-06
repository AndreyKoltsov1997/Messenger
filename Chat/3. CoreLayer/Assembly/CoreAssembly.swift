//
//  CoreAssembly.swift
//  Chat
//
//  Created by Andrey Koltsov on 20/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    // SQLite-based Storage
    var coreDataStorage: StorageCoreData { get }
    
    // File System Storage
    var gcdDataManager: GCDDataManager { get }
    var operationsDataManager: OperationDataManager { get }
    
    // Network Operations
    var requestSender: IRequestSender { get }
    var requestLoader: IRequestLoader { get }
}


class CoreAssembly: ICoreAssembly {
    lazy var gcdDataManager = GCDDataManager()
    lazy var operationsDataManager = OperationDataManager()
    lazy var coreDataStorage = StorageCoreData()

    lazy var requestSender: IRequestSender = RequestSender()
    lazy var requestLoader: IRequestLoader = RequestLoader()
}


