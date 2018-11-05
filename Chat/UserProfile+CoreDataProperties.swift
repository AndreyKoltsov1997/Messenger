//
//  UserProfile+CoreDataProperties.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//
//

import Foundation
import CoreData


extension UserProfile {
    public static let TAG = String(describing: UserProfile.self)

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: TAG)
    }

    @NSManaged public var name: String?
    @NSManaged public var discription: String?
    @NSManaged public var image: NSData?
}
