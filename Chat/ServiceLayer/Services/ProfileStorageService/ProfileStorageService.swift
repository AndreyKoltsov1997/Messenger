//
//  ProfileStorageService.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol IProfileStorageService {
    func loadProfile(completion: @escaping (_ name: String?, _ discription: String?, _ image: NSData?) -> Void)
    func saveProfile(_ name: String?, _ discription: String?, _ image: NSData?)
}

class ProfileStorageService {
    
    var storageManager: IStorageManagerService
    
    init(storageManager: IStorageManagerService) {
        self.storageManager = storageManager
    }
    
}

// MARK: - IProfileStorageService
extension ProfileStorageService: IProfileStorageService {
    func loadProfile(completion: @escaping (String?, String?, NSData?) -> Void) {
        self.storageManager.loadProfile(completion: completion)
    }
    
    func saveProfile(_ name: String?, _ discription: String?, _ image: NSData?) {
        self.storageManager.saveProfile(name, discription, image)
    }
    
    
}
