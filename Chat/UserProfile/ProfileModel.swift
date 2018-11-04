//
//  ProfileModel.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

class ProfileModel {
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
    
    init() {
        
        StorageCoreData.loadProfile { fetchedName, fetchedDiscription, fetchedImage in
            DispatchQueue.main.async {
                if let fetchedName = fetchedName {
                    self.name = fetchedName
                    print("Fetched name", fetchedName)
                }
                
                if let fetchedDiscription = fetchedDiscription {
                     self.discripton = fetchedDiscription
                }
                if let fetchedImage = fetchedImage as Data? {
                    self.image = fetchedImage
                } else {
                    print("Couldn't convert binary to image.")
                }
                self.delegate?.finishLoading(self)
            }
            
        }
    }
}
