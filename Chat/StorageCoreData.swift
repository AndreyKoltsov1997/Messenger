//
//  StorageCoreData.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import CoreData

// NOTE: @StorageCoreData is used to manage data operations with NSPersistentContainer. It's a single-ton because ...
// ... I think it's better to have a single instance of a class which is working with core memory.
class StorageCoreData: ProfileStorageManager {
    
    
    
    // MARK: - Core Data stack
    
    public static let TAG = String(describing: StorageCoreData.self)
    
    // NOTE: Constructor is private in order to confirm to Singleton pattern
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: Constants.PROFILE_MODEL_TAG)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(StorageCoreData.TAG, "An error has occured while loading the data:", error)
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print(StorageCoreData.TAG, "Context has been updated")
            } catch {
                print(StorageCoreData.TAG,"An error has pccured while saveing the data:", error.localizedDescription)
            }
        }
    }
    
    static func loadProfile(completion: @escaping (_ name: String?, _ discription: String?, _ image: NSData?) -> Void) {
        StorageCoreData.persistentContainer.performBackgroundTask { (backgroundContext) in
            let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
            do {
                let userProfileInfo = try StorageCoreData.context.fetch(fetchRequest)
                if !userProfileInfo.isEmpty {
                    let userName = userProfileInfo.first?.name
                    let userDiscription = userProfileInfo.first?.discription
                    guard let image = userProfileInfo.first?.image else {
                        completion(userName, userDiscription, nil)
                        return
                    }
                    completion(userName, userDiscription, image)
                } else {
                    // NOTE: Returning nothing.
                    completion(nil, nil, nil)
                }
            } catch {
                // TODO: Handle error correctly
                print(StorageCoreData.TAG, "An error has occured while loading profile info:", error.localizedDescription)
            }
        }
    }
    
    static func saveProfile(_ name: String?, _ discription: String?, _ image: NSData?) {
        StorageCoreData.context.performAndWait {
            let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
            if (StorageCoreData.isEntityExist(withName: String(describing: UserProfile.self), withIn: fetchRequest)) {
                // NOTE: Changing existing profile info
                do {
                    let userProfileInfo = try StorageCoreData.context.fetch(fetchRequest)
                    userProfileInfo.first?.name = name
                    userProfileInfo.first?.discription = discription
                    if let image = image as NSData? {
                        userProfileInfo.first?.image = image
                    } else {
                        print(TAG, "Unable to save image.")
                    }
                    StorageCoreData.saveContext()
                } catch {
                    // TODO: Handle error correctly
                    print(StorageCoreData.TAG, "An error has occured while re-writing profile info:", error.localizedDescription)
                }
            } else {
                let userProfile = UserProfile(context: StorageCoreData.context)
                userProfile.name = name
                userProfile.discription = discription
                if let image = image as NSData? {
                    userProfile.image = image
                } else {
                    print(TAG, "Unable to save image.")
                }
                StorageCoreData.saveContext()
            }
            
        }
    }
    
    
    static func isEntityExist(withName name: String, withIn fetchRequest: NSFetchRequest<UserProfile>) -> Bool {
        fetchRequest.includesSubentities = false
        var entitiesCount = 0
        do {
            entitiesCount = try StorageCoreData.context.count(for: fetchRequest)
        }
        catch {
            print(TAG, "An error has occured while counting required entities:", error.localizedDescription)
        }
        return entitiesCount > 0
    }
    
    
}


// MARK: - Operations With Contacts
extension StorageCoreData {
    // NOTE: получение пользователей онлайн
    
    static func getOnlineContacts() -> [ContactCD]? {
        guard let fetchRequest = FetchRequestTemplates.getOnlineUsers() else {
            print("template for fetching online users hasn't been found.")
            return nil
        }
        do {
            let onlineContacts = try StorageCoreData.context.fetch(fetchRequest)
            return onlineContacts
        } catch {
            // TODO: Handle error correctly
            print(StorageCoreData.TAG, "An error has occured while loading the contacts:", error.localizedDescription)
            return nil
        }
    }
    
    static func getContacts() -> [ContactCD]? {
        //   let fetchRequest: NSFetchRequest<ContactCD> =
        guard let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest() else {
            print("template for fetching contacts hasn't been found.")
            return nil
        }
        do {
            let onlineContacts = try StorageCoreData.context.fetch(fetchRequest)
            return onlineContacts
        } catch {
            // TODO: Handle error correctly
            print(StorageCoreData.TAG, "An error has occured while loading the contacts:", error.localizedDescription)
            return nil
        }
    }
    
    
    static func saveContact(_ contact: Contact) {
        // TODO: Check if entity exist
        
        StorageCoreData.context.performAndWait {
            // NOTE: First, generating a contact. Secondly, generating a converssation for it.
            let storedConract = NSEntityDescription.insertNewObject(forEntityName: String(describing: ContactCD.self), into: StorageCoreData.context) as? ContactCD
            // TODO: Add ID storing
            storedConract?.isOnline = contact.isOnline
            storedConract?.name = contact.name
            storedConract?.isInviteConfirmed = false
            storedConract?.id = String(contact.getIdentifier())
            
            // TODO: Handle invite confirmation
            storedConract?.isInviteConfirmed = false
            
            // NOTE: Generating conversation for contact
            let conversation = Conversation(context: context)
            conversation.id = StorageCoreData.getUniqueIdentifierForConversation()
            
            // NOTE: Binding user and conversation
            conversation.contact = storedConract
            
            StorageCoreData.saveContext()
        }
    }
    
    // NOTE: получение пользователя с определенным userId
    
    static func getContact(withID id: String) -> ContactCD? {
        guard let fetchRequest = FetchRequestTemplates.getContactByID(withID: id) else {
            print("Requested template for contact fetch request hasn't been found")
            return nil
        }
        fetchRequest.includesSubentities = false
        var contact: ContactCD? = nil
        do {
            contact = try StorageCoreData.context.fetch(fetchRequest).first
        } catch {
            print("An error has occured while fetching conversation.")
        }
        return contact
    }
    
    static func changeContactStatus(withID id: String, toStatus isOnline: Bool) {
        let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        let context = StorageCoreData.context
        context.performAndWait {
            do {
                guard let matchingContact = try? context.fetch(fetchRequest) else {
                    print("No contact has been found with requested id", id)
                    return
                }
                if matchingContact.isEmpty {
                    print("No contact has been found with requested id", id)
                    return
                }
                matchingContact.first?.isOnline = isOnline
                try context.save()
            } catch {
                print("An error has occured while fetching contact with ID:", error.localizedDescription)
                return
            }
        }
    }
}


// MARK: - Operations With Conversation
extension StorageCoreData {
    
    
    
    static var conversationSortDiscriptors: [NSSortDescriptor] {
        let isContactOnline = NSSortDescriptor(key: "contact.isOnline", ascending: false)
        return [isContactOnline]
    }
    
    private static var conversationFactory = 0
    private static func getUniqueIdentifierForConversation() -> String {
        conversationFactory += 1
        return String(StorageCoreData.conversationFactory)
    }
    
    
    // NOTE: получение беседы (Conversation) с определенным conversationId
    
    static func getConversation(withID id: String) -> Conversation? {
        var fetcedConversation: Conversation?
        guard let fetchRequest = FetchRequestTemplates.getConversationByID(withID: id) else {
            print("template for fetching conversations hasn't been found.")
            return nil
        }
        let context = StorageCoreData.context
        context.performAndWait {
            guard let conversation = try? context.fetch(fetchRequest) else {
                print("Unable to fetch conversations with requested ID")
                return
            }
            if !conversation.isEmpty {
                fetcedConversation = conversation.first
            }
        }
        return fetcedConversation
    }
    
    
    // NOTE получение непустых бесед, в которых пользователь (User) онлайн
    static func getNonEmptyConversationsForOnlineUsers() -> [Conversation]? {
        var conversations: [Conversation]?
        
        let predicate = NSPredicate(format: "isOnline == %@", true)
        let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
        fetchRequest.predicate = predicate
        
        let context = StorageCoreData.context
        context.performAndWait {
            guard let onlineUsers = try? context.fetch(fetchRequest) else {
                return
            }
            for user in onlineUsers {
                guard let conversation = user.conversation else {
                    continue
                }
                guard let messages = conversation.messages else {
                    continue
                }
                
                if !messages.isEmpty {
                    conversations?.append(conversation)
                }
            }
            
        }
        return conversations
    }
    
    // NOTE: получение сообщений (Message) из определенной беседы по id беседы
    
    static func getMessageFromConversation(withID id: String) -> [MessageCD]? {
        var messages: [MessageCD]?
        
        let predicate = NSPredicate(format: "id == %@", id)
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        fetchRequest.predicate = predicate
        let context = StorageCoreData.context
        context.performAndWait {
            guard let conversation = try? context.fetch(fetchRequest).first else {
                return
            }
            guard let foundMessages = conversation?.messages else {
                return
            }
            messages = foundMessages
            
        }
        return messages
    }
    
    static func saveConversation(_ conversation: ConversationModel) {
        
        // TODO: Check if entiity exist
        
        StorageCoreData.persistentContainer.performBackgroundTask { (backgroundContext) in
            let storedConversation = NSEntityDescription.insertNewObject(forEntityName: String(describing: Conversation.self), into: backgroundContext) as? Conversation
            if let contact = StorageCoreData.getContact(withID: String(conversation.contactID)) {
                storedConversation?.contact = contact
            }
            // TODO: Add dynamic "hasUnreadMessages"
            storedConversation?.hasUnreadMessages = false
            storedConversation?.id = String(conversation.identifier)
            storedConversation?.messages = nil
            StorageCoreData.saveContext()
        }
    }
}

// MARK: - Operations With Messages
extension StorageCoreData {
    static func saveMessage(_ message: Message, withIn conversation: Conversation) {
        StorageCoreData.persistentContainer.performBackgroundTask { (backgroundContext) in
            let storedMessage = NSEntityDescription.insertNewObject(forEntityName: String(describing: MessageCD.self), into: backgroundContext) as? MessageCD
            storedMessage?.date = message.date as NSDate
            storedMessage?.text = message.text
            storedMessage?.isReceived = message.isRecived
            storedMessage?.id = message.identifier
            storedMessage?.conversation = conversation
            StorageCoreData.saveContext()
        }
    }
}
