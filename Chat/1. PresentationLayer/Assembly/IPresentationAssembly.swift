//
//  IPresentationAssembly.swift
//  Chat
//
//  Created by Andrey Koltsov on 20/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
    // Screen with chat
    func conversationViewController() -> ConversationViewController
    
    // Screen with list of chats with users
    func conversationListViewController() -> ConversationListViewController

    // Screen with user profile
    func profileViewController() -> ProfileViewController?
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly

    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationViewController() -> ConversationViewController {
        let conversationViewController = ConversationViewController()
        return conversationViewController
    }
    
    func conversationListViewController() -> ConversationListViewController {
        let storyboard = UIStoryboard(name: "ConversationListViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        
        guard let navigator = controller as? UINavigationController else { fatalError() }
        
         guard let conversationListViewController = navigator.viewControllers.first as? ConversationListViewController else { fatalError() }
        
        conversationListViewController.setupViewController(presentationAssembly: self, storage: serviceAssembly.storageManagerService(), communicationService: serviceAssembly.communicationService(displayingName: "Andrey Koltsov"), contactProcessingService: serviceAssembly.contactProcessingService())
                return conversationListViewController
    }
    
    func profileViewController() -> ProfileViewController? {
        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ProfileViewController
        profileViewController?.configureViewController(profileStorageService: serviceAssembly.profileStorageService())
        return profileViewController
    }
    
    
}
