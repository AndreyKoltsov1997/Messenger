
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
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return Contact.identifierFactory
    }
    private var identifier: Int
    
    // NOTE: last message in dialogue
    var message: String?
   // var dialoque: [Message] = []
    var conversation: ConversationModel!
    var date: Date?
    
    var hasUnreadMessages: Bool
    var isOnline: Bool = false
    var isInviteConfirmed: Bool = false
    
    // TODO: Change to Int64? 
    public func getIdentifier() -> String {
    return String(self.identifier)
    }
    
    init(peer: Peer!, message: String?, date: Date?, hasUnreadMessages: Bool, isOnline: Bool) {
        self.identifier = Contact.getUniqueIdentifier()
        self.name = peer.name
        self.conversation = ConversationModel(withContact: peer)
        self.hasUnreadMessages = hasUnreadMessages
        if (message != nil) && (conversation.dialoque.isEmpty) {
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
        if let lastMessage = self.conversation.dialoque.last?.text {
            return lastMessage
        }
        return Constants.EMPTY_MESSAGE_HISTORY_TAG
    }
    
    public func getLastMessageDate() -> Date {
        if let lastMessageDate = self.conversation.dialoque.last?.date {
            return lastMessageDate
        }
        return Date()
    }
    
    
    // MARK: - Comparators
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.peer.identifier == rhs.peer.identifier
    }
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        let lhsDate = lhs.date ?? Date(timeIntervalSince1970: 0)
        let rhsDate = rhs.date ?? Date(timeIntervalSince1970: 0)
        
        return  lhsDate == rhsDate ? lhs.name ?? "" < rhs.name ?? "" : lhsDate > rhsDate
    }
}
