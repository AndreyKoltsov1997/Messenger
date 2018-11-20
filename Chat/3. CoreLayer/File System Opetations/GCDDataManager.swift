//
//  SaveViaGCD.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

protocol IDataManager {
    func loadProfile(sender: UIViewController)
    func saveProfile(sender: ProfileModel)
}
class GCDDataManager {
    
    // Dependencies
    private let profileStorageService: IProfileStorageService? = nil
    
    let concurrentQueue = DispatchQueue(label: "Tinkoff.GCDDataManager.concurrent", attributes: .concurrent)
    var profileInfo: ProfileModel?
    var hasValueChanged: Bool? = true
    weak var delegate: ProfileViewControllerDelegate?
    
}

// MARK: - IDataManager

extension GCDDataManager: IDataManager {
    
    public func loadProfile(sender: UIViewController) {
        let group = DispatchGroup()
        if let profileStorageService = profileStorageService {
            self.profileInfo = ProfileModel(profileStorageService: profileStorageService)
        }
        
        
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
            if FileLoader.getImage(fileName: FileName.USER_PROFILE_PICTURE_FILENAME.rawValue) != nil {
                // TODO: Update image here
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            if sender is ProfileViewController {
                if let profileInfo = self.profileInfo {
                    self.delegate?.finishLoading(profileInfo)
                    
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
        
        var image = UIImage()
        if let imageData = sender.image {
            image = UIImage(data: imageData, scale: 1.0) ?? UIImage()
        }
        
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
            self.hasValueChanged = FileSaver.saveImage(image: image, fileName: FileName.USER_PROFILE_PICTURE_FILENAME.rawValue)
            group.leave()
        }
        
        group.notify(queue: .main) {
            sender.onFinishSaving()
            
        }
    }
}
