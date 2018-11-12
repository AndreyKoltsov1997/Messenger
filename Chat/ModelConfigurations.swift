//
//  ModelConfigurations.swift
//  Chat
//
//  Created by Andrey Koltsov on 11/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import CoreData

// MARK: - Contact
extension ContactCD {
    static func getUniqueIdentifier() -> String {
        if let identifier =  "Contact\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString() {
            return identifier
        }
        return "Contact" + String(Date.timeIntervalSinceReferenceDate)
    }
    
    static func getSortDescriptors() -> [NSSortDescriptor] {
        let isOnline = NSSortDescriptor(key: "isOnline", ascending: false)
        return [isOnline]
    }
    
}


// MARK: - Conversation

extension Conversation {
    
    static func getUniqueIdentifier() -> String {
        if let identifier =  "Conversation\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString() {
            return identifier
        }
        return "Conversation" + String(Date.timeIntervalSinceReferenceDate)
    }
    
    static func getRelationPredicate(relatedTo conversationId: String) -> NSPredicate {
        return NSPredicate(format: "conversation.id == %@", conversationId)
    }
    
    static func getSortDescriptors() -> [NSSortDescriptor] {
        let isOnline = NSSortDescriptor(key: "contact.isOnline", ascending: false)
        let lastMessageDate = NSSortDescriptor(key: "lastMessageDate", ascending: false)
        let contactName = NSSortDescriptor(key: "contact.name", ascending: true)
        return [isOnline, lastMessageDate, contactName]
    }
}


// MARK: - Message

extension MessageCD {
    
    static func getUniqueIdentifier() -> String {
        if let identifier =  "Message\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString() {
            return identifier
        }
        return "Message" + String(Date.timeIntervalSinceReferenceDate)
    }
    
    static func getSortDescriptor() -> [NSSortDescriptor] {
        let sortingByDatePredicate = NSSortDescriptor(key: "date", ascending: true)
        return [sortingByDatePredicate]
    }
    
    static func getRelationPredicate(relatedTo conversationId: String) -> NSPredicate {
        return NSPredicate(format: "conversation.id == %@", conversationId)
    }
}
