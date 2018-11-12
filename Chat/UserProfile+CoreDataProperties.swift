//
//  UserProfile+CoreDataProperties.swift
//  Chat
//
//  Created by Andrey Koltsov on 12/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var discription: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?

}
