//
//  Message.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class Message {
    let sender: Contact?
    var date: Date
    var text: String
    public var isUnread = false
    
    init(withText text: String, from contact: Contact, recivedIn date: Date) {
        self.sender = contact
        self.text = text
        self.date = Calendar.current.date(byAdding: .day, value: contact.identifier, to: Date())!
    }
    

    
    init() {
        self.text = "No messages yet"
        self.date = Date()
        self.sender = nil
    }
}
