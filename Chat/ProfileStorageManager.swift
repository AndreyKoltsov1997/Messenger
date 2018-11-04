//
//  ProfileStorageManager.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol ProfileStorageManager: class {
    static func loadProfile(completion: @escaping (_ name: String?, _ discription: String?, _ image: NSData?) -> Void)
    static func saveProfile(_ name: String?, _ discription: String?, _ image: NSData?)
    static func isEntityExist(withName name: String) -> Bool
    
}
