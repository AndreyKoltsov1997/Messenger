
//
//  File.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class Contact: ConversationCellConfiguration {
    public let identifier: String
    var name: String?
    var peer: Peer!
    var message: String?
    var date: Date?
    var hasUnreadMessages: Bool
    var isOnline: Bool = false



    
    init(peer: Peer!, message: String?, date: Date?, hasUnreadMessages: Bool, isOnline: Bool) {
        self.name = peer.name
        self.identifier = peer.identifier

        self.hasUnreadMessages = hasUnreadMessages
        if (message != nil) && (message!.isEmpty) {
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
        self.isOnline = isOnline
    }
    
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
