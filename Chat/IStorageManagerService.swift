//
//  ProfileStorageManager.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import CoreData

protocol IStorageManagerService: class {
    
     func loadProfile(completion: @escaping (_ name: String?, _ discription: String?, _ image: NSData?) -> Void)
     func saveProfile(_ name: String?, _ discription: String?, _ image: NSData?)
     func isEntityExist(withName name: String, withIn fetchRequest: NSFetchRequest<UserProfile>) -> Bool
    
}
