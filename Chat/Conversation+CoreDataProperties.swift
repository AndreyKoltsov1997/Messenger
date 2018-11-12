//
//  Conversation+CoreDataProperties.swift
//  Chat
//
//  Created by Andrey Koltsov on 12/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var hasUnreadMessages: Bool
    @NSManaged public var id: String?
    @NSManaged public var lastMessageDate: NSDate?
    @NSManaged public var lastMessageText: String?
    @NSManaged public var contact: ContactCD?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension Conversation {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageCD)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageCD)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
