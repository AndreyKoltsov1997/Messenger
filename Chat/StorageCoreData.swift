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
        StorageCoreData.persistentContainer.performBackgroundTask { (backgroundContext) in
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
