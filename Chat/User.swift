//
//  User.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

struct User {
    private var name: String?
    private var isOnline: Bool = false
    private(set) var contacts = [Contact]()
    public var recivedMessages = [Message]()
    
    init() {
        self.initWithDefaultContacts()
        self.fillUpTestMessages()
    }
    
    private mutating func fillUpTestMessages() {
        for i in 0 ..< self.contacts.count {
            let currentDate = Date()
            let newMessage = Message(withText: "msg num \(i)", from: self.contacts[i], recivedIn: currentDate)
            // NOTE: Some test messages will be marked as unread if they're deviding by 3
            if (i%3) == 0 {
                newMessage.isUnread = true
                newMessage.date = Date(timeIntervalSinceReferenceDate: -123456789.0) // Feb 2, 1997, 10:26 AM
            } else if (i%3) == 1 {
                newMessage.text = ""
            }
            
            self.recivedMessages.append(newMessage)
        }
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
        let MINIMAL_AMOUNT_OF_TEST_CONTACTS = 20
        for i in 1 ... MINIMAL_AMOUNT_OF_TEST_CONTACTS {
            let currentContact = Contact()
            currentContact.name = "User num. \(i)"
            contacts.append(currentContact)
            // NOTE: Some conctacts will be marked as offline if their ID is deviding by 2
            if (i % 2) == 0 {
                currentContact.isOnline = true
            }
        }
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
