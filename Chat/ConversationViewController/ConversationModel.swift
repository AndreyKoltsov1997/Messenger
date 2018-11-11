//
//  Conversation.swift
//  Chat
//
//  Created by Andrey Koltsov on 11/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class ConversationModel {
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return ConversationModel.identifierFactory
    }
     public var identifier: Int
    
    var dialoque: [Message] = []
    var contact: Peer!
    
    init(withContact contact: Peer) {
        self.contact = contact
        self.identifier = ConversationModel.getUniqueIdentifier()
    }
    
    
    
}
