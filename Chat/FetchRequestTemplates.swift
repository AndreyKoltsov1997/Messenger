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

    
    // NOTE: получение беседы (Conversation) с определенным conversationId
    
    static func getConversationByID(withID id: String) -> NSFetchRequest<Conversation>? {
        guard let fetchRequest = StorageCoreData.persistentContainer.managedObjectModel.fetchRequestFromTemplate(withName: "ConversationById", substitutionVariables: ["ID":id]) as? NSFetchRequest<Conversation> else {
            print("getConversationByID request hasn't been found.")
            return nil
        }
        return fetchRequest
    }
    

    // NOTE: получение пользователя с определенным userId
    static func getContactByID(withID id: String) -> NSFetchRequest<ContactCD>? {
        guard let fetchRequest = StorageCoreData.persistentContainer.managedObjectModel.fetchRequestFromTemplate(withName: "ContactById", substitutionVariables: ["ID":id]) as? NSFetchRequest<ContactCD> else {
            print("getContactByID request hasn't been found.")
            return nil
        }
        return fetchRequest
    }
    
    // NOTE: получение пользователей онлайн
    static func getOnlineUsers() -> NSFetchRequest<ContactCD>? {
        guard let fetchRequest = StorageCoreData.persistentContainer.managedObjectModel.fetchRequestFromTemplate(withName: "GetOnlineContacts", substitutionVariables: [:]) as? NSFetchRequest<ContactCD> else {
            print("GetOnlineUContacts request hasn't been found.")
            return nil
        }
        return fetchRequest
    }
    
    // NOTE: получение непустых бесед, в которых пользователь (User) онлайн
    static func getNonEmptyConversations(isUserOnline isOnline: Bool) -> NSFetchRequest<Conversation> {
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
       
        let nonEmptyPredicate = NSPredicate(format: "messages != nil")
        let userOnlinePredicate = NSPredicate(format: "user.isOnline == \(isOnline)")
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [nonEmptyPredicate, userOnlinePredicate])
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    // NOTE: получение сообщений (Message) из определенной беседы по id беседы
    static func getMessagesFromConversation(withID conversationId: String) -> NSFetchRequest<MessageCD> {
        let fetchRequest: NSFetchRequest<MessageCD> = MessageCD.fetchRequest()
        let conversationIdPredicate = NSPredicate(format: "conversation.id == %@", conversationId)
        fetchRequest.predicate = conversationIdPredicate
        return fetchRequest
    }
    
    
}
