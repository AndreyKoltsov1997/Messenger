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
    
    
    // MARK: - Dependencies
    
    private var profileStorageService: IProfileStorageService?
    
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
    
    init(profileStorageService: IProfileStorageService) {
        self.profileStorageService = profileStorageService
        self.loadFromCoreData()
    }
    
    // MARK: - Methods
    
    public func loadFromCoreData() {
        guard let profileStorageService = profileStorageService else {
            print(ProfileModel.TAG, "Storage Service hasn't been initialized")
            self.delegate?.onFinishSaving()
            return
        }
        profileStorageService.loadProfile { fetchedName, fetchedDiscription, fetchedImage in
            if ((fetchedName == nil) && (fetchedDiscription == nil) && (fetchedImage == nil)) {
                print(ProfileModel.TAG, "Unable to find any saved info for user profile")
                self.delegate?.onFinishSaving()
                return
            }
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

    
    public func saveIntoCoreData() {
        DispatchQueue.main.async {
            guard let profileStorageService = self.profileStorageService else {
                print("Storage hasn't been initialized")
                self.delegate?.onFinishSaving()
                return
            }
            if let image = self.image as NSData? {
                profileStorageService.saveProfile(self.name, self.discripton, image)
            } else {
                profileStorageService.saveProfile(self.name, self.discripton, nil)
                
            }
            self.delegate?.onFinishSaving()
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
