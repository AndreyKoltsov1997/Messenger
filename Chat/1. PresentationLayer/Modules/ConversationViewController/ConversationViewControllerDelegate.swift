//
//  ConversationViewControllerDelegate.swift
//  Chat
//
//  Created by Andrey Koltsov on 06/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//


protocol ConversationViewControllerDelegate: class {
    func loadDialoque(withContact contact: Contact)
}
