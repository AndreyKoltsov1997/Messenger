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
    var profileInfo: ProfileModel?
    var hasValueChanged: Bool? = true
    weak var delegate: ProfileViewControllerDelegate?
    
    public func loadProfile(sender: UIViewController) {
        let group = DispatchGroup()
        self.profileInfo = ProfileModel()
        
        group.enter()
        concurrentQueue.async {
            if let name = FileLoader.getText(fileName: FileName.USERNAME_FILENAME.rawValue) {
                self.profileInfo?.name = name
            }
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            if let discription = FileLoader.getText(fileName: FileName.USER_DISCRIPTION_FILENAME.rawValue) {
                self.profileInfo?.discripton = discription
            }
            
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            if let image = FileLoader.getImage(fileName: FileName.USER_PROFILE_PICTURE_FILENAME.rawValue) {
                // TODO: Update image here
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let distinationViewController = sender as? ProfileViewController {
                if let profileInfo = self.profileInfo {
                    self.delegate?.finishLoading(profileInfo)
//                    distinationViewController.configureProfile(profileInfo: profileInfo)
                } else {
                    print("User data hasn't changed yet.")
                }
            } else if let distinationViewController = sender as? ConversationListViewController {
                if let profileInfo = self.profileInfo {
                    // TODO: Update user picture @ profileViewController here
                    distinationViewController.configureProfile(profileInfo: profileInfo)
                } else {
                    print("User data hasn't changed yet.")
                }
            }
            
        }
    }
    
    public func saveProfile(sender: ProfileModel) {
        let group = DispatchGroup()
        
        
        let username = profileInfo?.name
        let information = profileInfo?.discripton
        let image = UIImage(data: sender.image as! Data, scale: 1.0)
        
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
            sender.onFinishSaving()
            
        }
    }
}
