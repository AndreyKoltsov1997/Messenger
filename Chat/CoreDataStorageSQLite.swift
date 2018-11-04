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

class CoreDataStorageSQLite {
    
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "ProfileModel", withExtension: "momd") else {
            return nil
        }
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        
        return managedObjectModel
    }()
    
    private var persistentStoreURL: NSURL {
        let storeName = "ProfileModel.sqlite"
        let fileManager = FileManager.default
        let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        return documentDirectoryURL.appendingPathComponent(storeName) as NSURL
    }
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let managedObjectModel = self.managedObjectModel else {
            return nil
        }
        
        let persistentStoreURL = self.persistentStoreURL
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL as URL, options: options)
        } catch {
            let error = error as NSError
            print("\(error.localizedDescription)")
        }
        return persistentStoreCoordinator
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    
    
    func save(profile: ProfileModel) {
        
        if (self.isEntityExist(withName: UserProfile.TAG)) {
            let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
            do {
                let userProfileInfo = try self.privateManagedObjectContext.fetch(fetchRequest)
                if !userProfileInfo.isEmpty {
                    userProfileInfo.last?.name = profile.name
                    userProfileInfo.last?.discription = profile.discripton
                    guard let image = profile.image as NSData? else {
                        return
                    }
                    userProfileInfo.last?.image = image
                }
            } catch {
                print("An error has occured while re-writing profile info:", error.localizedDescription)
            }
        } else {
            let userProfile = NSEntityDescription.insertNewObject(forEntityName: UserProfile.TAG, into: self.privateManagedObjectContext) as? UserProfile
            userProfile?.name = profile.name
            userProfile?.discription = profile.discripton
            guard let image = profile.image as NSData? else {
                userProfile?.image = nil
                return
            }
            userProfile?.image = image
        }
        
        
        do {
            try privateManagedObjectContext.save()
        } catch {
            print("An error has occured while saving data into SQLite:", error.localizedDescription)
        }
    }
    
    func loadProfile(completion: @escaping (_ name: String?, _ discription: String?, _ image: NSData?) -> Void) {
        
        DispatchQueue.main.async {
            let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
            do {
                let userProfileInfo = try self.privateManagedObjectContext.fetch(fetchRequest)
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
    func isEntityExist(withName name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.includesSubentities = false
        var entitiesCount = 0
        do {
            entitiesCount = try self.privateManagedObjectContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return entitiesCount > 0
    }
}
