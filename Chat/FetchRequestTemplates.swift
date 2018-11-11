//
//  FetchRequestTemplates.swift
//  Chat
//
//  Created by Andrey Koltsov on 11/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import CoreData

class FetchRequestTemplates {
    
    // NOTE: Constructor is private in order to confirm to Singleton pattern
    private init() {}

    
    static func getConversationByID(withID id: String) -> NSFetchRequest<Conversation>? {
        guard let fetchRequest = StorageCoreData.persistentContainer.managedObjectModel.fetchRequestFromTemplate(withName: "ConversationById", substitutionVariables: ["ID":id]) as? NSFetchRequest<Conversation> else {
            return nil
        }
        return fetchRequest
    }
    
    func getMessagesFromConversation(withID id: String)  {
        let fetchRequest = FetchRequestTemplates.getConversationByID(withID: id)
//        guard let messages =  StorageCoreData.context.fetch(fetchRequest) as? NSFetchRequest<Conversation> else {
//            print("no data has been found")
//        }
//        print(messages)
    }
    
    
    
    
}
