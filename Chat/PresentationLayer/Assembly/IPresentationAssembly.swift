//
//  IPresentationAssembly.swift
//  Chat
//
//  Created by Andrey Koltsov on 20/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    // Screen with chat
    func conversationViewController() -> ConversationViewController
    
    // Screen with list of chats with users
    func conversationListViewController() -> ConversationListViewController

    // Screen with user profile
    func profileViewController() -> ProfileViewController
}

class PresentationAssembly: IPresentationAssembly {
    func conversationViewController() -> ConversationViewController {
        let conversationViewController = ConversationViewController()
        return conversationViewController
    }
    
    func conversationListViewController() -> ConversationListViewController {
        let conversationListViewController = ConversationListViewController()
        conversationListViewController.setupViewController(presentationAssembly: self)
        return conversationListViewController
    }
    
    func profileViewController() -> ProfileViewController {
        let profileViewController = ProfileViewController()
        return profileViewController
    }
    
    
}
