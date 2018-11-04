//
//  StorageCoreData.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import CoreData

class StorageCoreData {
    
    // MARK: - Core Data stack
    
    public static let TAG = String(describing: StorageCoreData.self)

    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ProfileModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                let nserror = error as NSError
                print(StorageCoreData.TAG,"An error has pccured while saveing the data \(nserror), \(nserror.userInfo)")
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
                }
            } catch {
                // TODO: Handle error correctly
                print(StorageCoreData.TAG, "An error has occured while loading profile info:", error.localizedDescription)
            }
        }
    }
    
    static func saveProfile(_ name: String?, _ discription: String?, _ image: NSData?) {
        StorageCoreData.persistentContainer.performBackgroundTask { (backgroundContext) in
            if (StorageCoreData.isEntityExist(withName: UserProfile.TAG)) {
                 let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
                do {
                    let userProfileInfo = try StorageCoreData.context.fetch(fetchRequest)
                    userProfileInfo.first?.name = name
                    userProfileInfo.first?.discription = discription
                    userProfileInfo.first?.image = image
                    StorageCoreData.saveContext()
                } catch {
                    // TODO: Handle error correctly
                    print(StorageCoreData.TAG, "An error has occured while re-writing profile info:", error.localizedDescription)
                }
                return
            }
            let userProfile = UserProfile(context: StorageCoreData.context)
            userProfile.name = name
            userProfile.discription = discription
            userProfile.image = image
            StorageCoreData.saveContext()
            print(StorageCoreData.TAG, "Context has been saved")
        }
    }
    
    static func isEntityExist(withName name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.includesSubentities = false
        var entitiesCount = 0
        do {
            entitiesCount = try StorageCoreData.context.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return entitiesCount > 0
    }
    
}
