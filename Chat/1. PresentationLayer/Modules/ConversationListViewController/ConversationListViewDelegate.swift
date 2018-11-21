//
//  ConversationListDelegate.swift
//  Chat
//
//  Created by Andrey Koltsov on 06/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

// NOTE: Custom Delegate specificly for updating UI. Is it a good practice to add more than 1 delegate on a VC?
protocol ConversationListViewDelegate: class {
    func addContact(_ contect: Contact)
    func updateImage(_ image: Data)
}
