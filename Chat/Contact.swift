
//
//  File.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class Contact: ConversationCellConfiguration {
    public let identifier: Int
    
    var name: String?
    var message: String?
    var date: Date?
    var hasUnreadMessages: Bool
    var isOnline: Bool = false


    var hasProfilePicture: Bool = false
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return Contact.identifierFactory
    }
    
    init(name: String?, message: String?, date:Date?, hasUnreadMessages: Bool, isOnline: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.hasUnreadMessages = hasUnreadMessages
        self.isOnline = isOnline
        self.identifier = Contact.getUniqueIdentifier()
    }
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
