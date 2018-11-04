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
        didSet(newValue) {
            delegate?.updateName(newValue)
        }
    }
    public var discripton = Constants.DEFAULT_USER_DISCRIPTION {
        didSet(newValue) {
            delegate?.updateDiscription(newValue)
        }
    }
    
    public var image: Data? {
        didSet(newValue) {
            if let newValue = newValue {
                delegate?.updateImage(newValue)
            }
        }
    }
        
    weak var delegate: ProfileViewControllerDelegate?
    
    
    // MARK: - Constructor
    
    init() {
        self.loadData()
    }
    
    // MARK: - Methods
    
    public func loadData() {
        StorageCoreData.loadProfile { fetchedName, fetchedDiscription, fetchedImage in
            DispatchQueue.main.async {
                if let fetchedName = fetchedName {
                    self.name = fetchedName
                    print(ProfileModel.TAG, "Fetched name", fetchedName)
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
    
    public func saveInfo() {
        DispatchQueue.main.async {
            if let image = self.image as NSData? {
                StorageCoreData.saveProfile(self.name, self.discripton, image)
            } else {
                print(ProfileModel.TAG, "Unable to save profile picture.")
            }
        }
    }
    
    // MARK: - GCD Operations
    
    public func saveViaGCD() {
        let gcdDataManager = GCDDataManager()
        gcdDataManager.saveProfile(sender: self)
    }
    
    public func onFinishSaving() {
        delegate?.onFinishSaving()
    }
}
