//
//  ContactCD+CoreDataProperties.swift
//  Chat
//
//  Created by Andrey Koltsov on 11/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactCD> {
        return NSFetchRequest<ContactCD>(entityName: "ContactCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var peer: NSData?
    @NSManaged public var isOnline: Bool
    @NSManaged public var conversation: Conversation?

}
