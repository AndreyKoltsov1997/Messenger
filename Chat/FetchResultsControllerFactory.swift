//
//  FetchResultsControllerFactory.swift
//  Chat
//
//  Created by Andrey Koltsov on 11/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import CoreData

class FetchResultsControllerFactory {
    
    // NOTE: Singleton
    private init() {}
    
    // MARK: - Conversation
    static func conversationFetchedResultsController() -> NSFetchedResultsController<Conversation> {
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        fetchRequest.sortDescriptors = Conversation.getSortDescriptors()
        fetchRequest.resultType = .managedObjectResultType
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: StorageCoreData.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    // MARK: - Contacts

    static func contactsFetchedResultsController() -> NSFetchedResultsController<ContactCD> {
        let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
        fetchRequest.sortDescriptors = ContactCD.getSortDescriptors()
        fetchRequest.resultType = .managedObjectResultType
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: StorageCoreData.context, sectionNameKeyPath: "isOnline", cacheName: nil)
        return fetchedResultsController
    }
    
    // MARK: - Messages
    
    static func messagesFetchedResultsController() -> NSFetchedResultsController<MessageCD> {
        let fetchRequest: NSFetchRequest<MessageCD> = MessageCD.fetchRequest()
        fetchRequest.sortDescriptors = MessageCD.getSortDescriptor()
        fetchRequest.resultType = .managedObjectResultType
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: StorageCoreData.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
}
