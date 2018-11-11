//
//  ConversationListViewControllerDelegate.swift
//  Chat
//
//  Created by Andrey Koltsov on 28/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

protocol ConversationListViewControllerDelegate: class {
    func updateDialogues(for contact: ContactCD)
    func sendMessage(_ message: MessageCD, to peer: Peer)
}
