//
//  MessageCD+CoreDataProperties.swift
//  Chat
//
//  Created by Andrey Koltsov on 11/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageCD> {
        return NSFetchRequest<MessageCD>(entityName: "MessageCD")
    }

    @NSManaged public var id: String!
    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var isReceived: Bool
    @NSManaged public var conversation: Conversation!

}
