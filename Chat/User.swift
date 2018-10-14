//
//  User.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

struct User {
    public var name: String?
    private var isOnline: Bool = false
    private(set) var contacts = [Contact]()
    public var recivedMessages = [Message]()
    
    init() {
        self.initWithDefaultContacts()
    }
    
    public func getLastRecivedMessage(from contact: Contact!) -> Message {
        var message = Message()
        for currentMessage in recivedMessages {
            if (currentMessage.sender != nil) && currentMessage.sender! == contact {
                message = currentMessage
            }
        }
        if (message.text == "") {
            message.text = "No messages yet"
        }
        return message
    }
    
    public func getRecivedMessages(from contact: Contact!) -> [Message] {
        var messages = [Message]()
        for currentMessage in recivedMessages {
            if (currentMessage.sender != nil) && currentMessage.sender! == contact {
                messages.append(currentMessage)
            }
        }
        return messages
    }
    
    private func getTotalAmountOfContacts() -> Int {
        let onlineContacts = getRequiredContacts(isOnline: true)
        let offlineContacts = getRequiredContacts(isOnline: false)
        return onlineContacts.count + offlineContacts.count
    }
    
    private mutating func initWithDefaultContacts() {
        
        
    }
    
    public func getRequiredContacts(isOnline requiredOnlineStatus: Bool) -> [Contact] {
        var requiredContacts = [Contact] ()
        for contact in self.contacts {
            if (contact.isOnline == requiredOnlineStatus) {
                requiredContacts.append(contact)
            }
        }
        return requiredContacts
    }
}
