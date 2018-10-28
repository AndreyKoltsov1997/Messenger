
//
//  File.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class Contact {
    
    var name: String?
    var peer: Peer!
    
    // NOTE: last message in dialogue
    var message: String?
    var dialoque: [Message] = []
    var date: Date?
    
    var hasUnreadMessages: Bool
    var isOnline: Bool = false

    

    init(peer: Peer!, message: String?, date: Date?, hasUnreadMessages: Bool, isOnline: Bool) {
        self.name = peer.name

        self.hasUnreadMessages = hasUnreadMessages
        if (message != nil) && (dialoque.isEmpty) {
            self.message = Constants.EMPTY_MESSAGE_HISTORY_TAG
            self.hasUnreadMessages = false
        } else if (message != nil) {
            self.message = message
        }

        if (date == nil) {
            self.date = Date()
        } else {
            self.date = date
        }
        self.peer = peer
        self.isOnline = isOnline
    }
    
    public func getLastMessageFromDialog() -> String {
        if let lastMessage = self.dialoque.last?.text {
            return lastMessage
        }
        return Constants.EMPTY_MESSAGE_HISTORY_TAG
    }
    
    public func getLastMessageDate() -> Date {
        if let lastMessageDate = self.dialoque.last?.date {
            return lastMessageDate
        }
        return Date()
    }
    
    
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.peer.identifier == rhs.peer.identifier
    }
}
