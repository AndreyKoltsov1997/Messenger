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

    
    // TODO: Merge "get...byID" functions into one generic function

    static func getConversationByID(withID id: String) -> NSFetchRequest<Conversation>? {
        guard let fetchRequest = StorageCoreData.persistentContainer.managedObjectModel.fetchRequestFromTemplate(withName: "ConversationById", substitutionVariables: ["ID":id]) as? NSFetchRequest<Conversation> else {
            print("getConversationByID request hasn't been found.")
            return nil
        }
        return fetchRequest
    }
    

    static func getContactByID(withID id: String) -> NSFetchRequest<ContactCD>? {
        guard let fetchRequest = StorageCoreData.persistentContainer.managedObjectModel.fetchRequestFromTemplate(withName: "ContactById", substitutionVariables: ["ID":id]) as? NSFetchRequest<ContactCD> else {
            print("getContactByID request hasn't been found.")
            return nil
        }
        return fetchRequest
    }
    
    static func getOnlineUsers() -> NSFetchRequest<ContactCD>? {
        guard let fetchRequest = StorageCoreData.persistentContainer.managedObjectModel.fetchRequestFromTemplate(withName: "GetOnlineUContacts", substitutionVariables: [:]) as? NSFetchRequest<ContactCD> else {
            print("GetOnlineUContacts request hasn't been found.")
            return nil
        }
        return fetchRequest
    }
    
    
    
}
