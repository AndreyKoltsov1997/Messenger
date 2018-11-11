//
//  StorageCoreDataWithoutPContainer.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// NOTE: @CoreDataStorageSQLite is used to manage data operations with NSPersistentContainer. It's a single-ton because ...
// ... I think it's better to have a single instance of a class which is working with core memory.

class CoreDataStorageSQLite: ProfileStorageManager {    
    
    public static let TAG = String(describing: CoreDataStorageSQLite.self)
    
    // NOTE: Constructor is private in order to confirm to Singleton pattern
    private init() {}
    
    static var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = CoreDataStorageSQLite.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    static var managedObjectModel: NSManagedObjectModel? = {
        guard let targetModelPath = Bundle.main.url(forResource: Constants.PROFILE_MODEL_TAG, withExtension: "momd") else {
            return nil
        }
        let managedObjectModel = NSManagedObjectModel(contentsOf: targetModelPath)
        return managedObjectModel
    }()
    
    static var persistentStoreURL: NSURL {
        let storageTarget = "\(Constants.PROFILE_MODEL_TAG).sqlite"
        let fileManager = FileManager.default
        let pathToDocumentDirictory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return pathToDocumentDirictory.appendingPathComponent(storageTarget) as NSURL
    }
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let managedObjectModel = CoreDataStorageSQLite.managedObjectModel else {
            return nil
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            let persistentStoreCoordinatorParameters = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL as URL, options: persistentStoreCoordinatorParameters)
        } catch {
            print(TAG, "An error has occured while configuring Persistent Store Coordinator:", error.localizedDescription)
        }
        return persistentStoreCoordinator
    }()
    
    
    static func saveProfile(_ name: String?, _ discription: String?, _ image: NSData?) {
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        if (CoreDataStorageSQLite.isEntityExist(withName: String(describing: UserProfile.self), withIn: fetchRequest)) {
            do {
                let userProfileInfo = try CoreDataStorageSQLite.privateManagedObjectContext.fetch(fetchRequest)
                if !userProfileInfo.isEmpty {
                    userProfileInfo.last?.name = name
                    userProfileInfo.last?.discription = discription
                    guard let image = image as NSData? else {
                        return
                    }
                    userProfileInfo.last?.image = image
                }
            } catch {
                print(TAG, "An error has occured while re-writing profile info:", error.localizedDescription)
            }
        } else {
            let userProfile = NSEntityDescription.insertNewObject(forEntityName: String(describing: UserProfile.self), into: CoreDataStorageSQLite.privateManagedObjectContext) as? UserProfile
            userProfile?.name = name
            userProfile?.discription = discription
            guard let image = image as NSData? else {
                userProfile?.image = nil
                return
            }
            userProfile?.image = image
        }
        
        do {
            try privateManagedObjectContext.save()
        } catch {
            print(TAG, "An error has occured while saving data into SQLite:", error.localizedDescription)
        }
    }
    
    static func loadProfile(completion: @escaping (_ name: String?, _ discription: String?, _ image: NSData?) -> Void) {
        
        DispatchQueue.main.async {
            let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
            do {
                let userProfileInfo = try CoreDataStorageSQLite.privateManagedObjectContext.fetch(fetchRequest)
                if !userProfileInfo.isEmpty {
                    let userName = userProfileInfo.last?.name
                    let userDiscription = userProfileInfo.last?.discription
                    guard let image = userProfileInfo.last?.image else {
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
}

extension CoreDataStorageSQLite {
    static func isEntityExist(withName name: String, withIn fetchRequest: NSFetchRequest<UserProfile>) -> Bool {
        fetchRequest.includesSubentities = false
        var entitiesCount = 0
        do {
            entitiesCount = try CoreDataStorageSQLite.privateManagedObjectContext.count(for: fetchRequest)
        }
        catch {
            print(TAG, "error executing fetch request:", error.localizedDescription)
        }
        return entitiesCount > 0
    }
}
