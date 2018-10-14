
//
//  File.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class Contact {
    public let identifier: Int
    public var name: String = "Unknown number"
    var isOnline: Bool = false
    var hasProfilePicture: Bool = false
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return Contact.identifierFactory
    }
    
    init() {
        self.identifier = Contact.getUniqueIdentifier()
    }
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
