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
    func conversationListViewController() -> UINavigationController

    // Screen with user profile
    func profileViewController() -> ProfileViewController?
    
    // Selection of User Profile Picture from fetched images
    
    func imageSelectionViewController() -> ImageSelectionViewController?
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
    
    func conversationListViewController() -> UINavigationController {
        let targetStoryboard = UIStoryboard(name: "ConversationListViewController", bundle: nil)
        let navigationController = targetStoryboard.instantiateViewController(withIdentifier: "NavigationController")
        
        guard let navigation = navigationController as? UINavigationController else { fatalError() }
        
         guard let conversationListViewController = navigation.viewControllers.first as? ConversationListViewController else { fatalError() }
        
        conversationListViewController.setupViewController(presentationAssembly: self, storage: serviceAssembly.storageManagerService(), communicationService: serviceAssembly.communicationService(displayingName: "Andrey Koltsov"), contactProcessingService: serviceAssembly.contactProcessingService())
                return navigation
    }
    
    func profileViewController() -> ProfileViewController? {
        let profileViewController = UIStoryboard(name: "ProfileViewController", bundle: nil).instantiateInitialViewController() as? ProfileViewController
        profileViewController?.configureViewController(profileStorageService: serviceAssembly.profileStorageService(), presentationAssembly: self)
        return profileViewController
    }
    
    func imageSelectionViewController() -> ImageSelectionViewController? {
        let imageSelectionViewController = UIStoryboard(name: "ImageSelectionViewController", bundle: nil).instantiateInitialViewController() as? ImageSelectionViewController
        imageSelectionViewController?.configureViewController(service: serviceAssembly.pixabayAPIService())
        return imageSelectionViewController
    }
    
    
}
