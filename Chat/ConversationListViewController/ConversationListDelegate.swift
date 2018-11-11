//
//  ConversationListDelegate.swift
//  Chat
//
//  Created by Andrey Koltsov on 06/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol ConversationListDelegate: class {
    func addContact(_ contect: Contact)
    func updateImage(_ image: Data)
}
