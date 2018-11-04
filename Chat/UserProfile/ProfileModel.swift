//
//  ProfileModel.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class ProfileModel {
    public static let TAG = String(describing: ProfileModel.self)

    // MARK: - Properties

    public var name = Constants.DEFAULT_USERNAME {
        didSet {
            delegate?.updateName(self.name)
        }
    }
    public var discripton = Constants.DEFAULT_USER_DISCRIPTION {
        didSet {
            delegate?.updateDiscription(discripton)
        }
    }
    
    public var image: Data? {
        didSet {
            if let image = image {
                delegate?.updateImage(image)
            }
        }
    }
        
    weak var delegate: ProfileViewControllerDelegate?
    
    
    // MARK: - Constructor
    
    init() {
        print("init")
        self.loadFromSQLite()
        // NOTE: To load using Core Data, use:
       // self.loadFromCoreData()
    }
    
    // MARK: - Methods
    
    public func loadFromCoreData() {
        StorageCoreData.loadProfile { fetchedName, fetchedDiscription, fetchedImage in
            DispatchQueue.main.async {
                if let fetchedName = fetchedName {
                    self.name = fetchedName
                }
                
                if let fetchedDiscription = fetchedDiscription {
                    self.discripton = fetchedDiscription
                }
                if let fetchedImage = fetchedImage as Data? {
                    self.image = fetchedImage
                } else {
                    print(ProfileModel.TAG, "Couldn't convert binary to image.")
                }
                self.delegate?.finishLoading(self)
            }
            
        }
    }
    
    public func loadFromSQLite() {
        DispatchQueue.main.async {
             CoreDataStorageSQLite.loadProfile { fetchedName, fetchedDiscription, fetchedImage in
                DispatchQueue.main.async {
                    if let fetchedName = fetchedName {
                        self.name = fetchedName
                    }
                    
                    if let fetchedDiscription = fetchedDiscription {
                        self.discripton = fetchedDiscription
                    }
                    if let fetchedImage = fetchedImage as Data? {
                        self.image = fetchedImage
                    } else {
                        print(ProfileModel.TAG, "Couldn't convert binary to image.")
                    }
                    self.delegate?.finishLoading(self)
                }
            }
        }
    }

    public func saveIntoCoreData() {
        DispatchQueue.main.async {
            if let image = self.image as NSData? {
                StorageCoreData.saveProfile(self.name, self.discripton, image)
            } else {
                StorageCoreData.saveProfile(self.name, self.discripton, nil)

            }

            
            self.delegate?.onFinishSaving()
        }
    }
    
    public func saveIntoSQLite() {
        DispatchQueue.main.async {
            if let image = self.image as NSData? {
                CoreDataStorageSQLite.saveProfile(self.name, self.discripton, image)
            } else {
                CoreDataStorageSQLite.saveProfile(self.name, self.discripton, nil)
            }
        }
    }
    
    // MARK: - GCD Operations
    
    public func saveViaGCD() {
        let gcdDataManager = GCDDataManager()
        gcdDataManager.saveProfile(sender: self)
    }
    
    // MARK: - Saving via operations methods
    
    public func saveViaOperations() {
        let operationManager = OperationDataManager()
        operationManager.saveProfile(profile: self)
    }
    
    public func onFinishSaving() {
        delegate?.onFinishSaving()
    }
}
