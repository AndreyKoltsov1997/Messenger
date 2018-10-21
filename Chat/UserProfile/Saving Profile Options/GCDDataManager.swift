//
//  SaveViaGCD.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class GCDDataManager {
    
    let concurrentQueue = DispatchQueue(label: "Tinkoff.GCDDataManager.concurrent", attributes: .concurrent)
    var profileInfo: ProfileInfo?
    var hasValueChanged: Bool? = true
    
    public func loadProfile(sender: UIViewController) {
        let group = DispatchGroup()
        self.profileInfo = ProfileInfo()
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.userName = FileLoader.getText(fileName: FileName.USERNAME_FILENAME.rawValue)
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.discription = FileLoader.getText(fileName: FileName.USER_DISCRIPTION_FILENAME.rawValue)
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.profilePicture = FileLoader.getImage(fileName: FileName.USER_PROFILE_PICTURE_FILENAME.rawValue)
            group.leave()
        }
        
        group.notify(queue: .main) {
            let distinationViewController = sender as! ProfileViewController
            if let profileInfo = self.profileInfo {
                distinationViewController.configureProfile(profileInfo: profileInfo)
            } else {
                print("User data hasn't changed yet.")
            }
        }
    }
    
    public func saveProfile(sender: UIViewController) {
        let group = DispatchGroup()
        
        let username = profileInfo?.userName
        let information = profileInfo?.discription
        let image = profileInfo?.profilePicture
        
        group.enter()
        concurrentQueue.async {
            if let username = username {
                self.hasValueChanged = FileSaver.saveText(text: username, fileName: FileName.USERNAME_FILENAME.rawValue)
            }
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            if let information = information {
                self.hasValueChanged = FileSaver.saveText(text: information, fileName: FileName.USER_DISCRIPTION_FILENAME.rawValue)
            }
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            if let image = image {
                self.hasValueChanged = FileSaver.saveImage(image: image, fileName: FileName.USER_PROFILE_PICTURE_FILENAME.rawValue)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            let distinationViewController = sender as! ProfileViewController
            distinationViewController.hasDataChanged = self.hasValueChanged
            
        }
    }
}
