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
    
    weak var delegate: ProfileViewControllerDelegate?
}
