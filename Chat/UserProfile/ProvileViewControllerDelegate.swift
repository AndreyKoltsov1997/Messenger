//
//  ProvileViewControllerDelegate.swift
//  Chat
//
//  Created by Andrey Koltsov on 04/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol ProfileViewControllerDelegate: class {
    func updateName(_ name: String)
    func updateDiscription(_ discription: String)
    func updateImage(_ image: Data)
    func finishLoading(_ model: ProfileModel)
}
