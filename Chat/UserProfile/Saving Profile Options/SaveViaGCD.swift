//
//  SaveViaGCD.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

struct ProfileInfo {
    var userName:String?
    var discription: String?
    var profilePicture: UIImage?
    
}
class GCDDataManager {
    let concurrentQueue = DispatchQueue(label: "TinkoffChat.GCD.concurrent", attributes: .concurrent)
    var profileInfo: ProfileInfo?
    var hasValueChanged: Bool? = true
    
    
    public func loadProfile(sender: UIViewController) {
        let group = DispatchGroup()
        self.profileInfo = ProfileInfo()
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.userName = FileOperation.LoadData.text(filename: FileName.username.rawValue)
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.discription = FileOperation.LoadData.text(filename: FileName.information.rawValue)
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.profilePicture = FileOperation.LoadData.image(filename: FileName.image.rawValue)
            group.leave()
        }
        
        group.notify(queue: .main) {
            let vc = sender as! ProfileViewController
            if let profileInfo = self.profileInfo {
                vc.configureProfile(profileInfo: profileInfo)
            } else {
                print("User data hasn't changed yet.")
            }
        }
        
    }
    
    internal func saveProfile(sender: Any) {
        let group = DispatchGroup()
        
        let username = profileInfo?.userName
        let information = profileInfo?.discription
        let image = profileInfo?.profilePicture
        
        group.enter()
        concurrentQueue.async {
            if let username = username {
                self.hasValueChanged = FileOperation.SaveData.text(text: username, filename: FileName.username.rawValue)

            }
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            if let information = information {
                self.hasValueChanged = FileOperation.SaveData.text(text: information, filename: FileName.information.rawValue)
            }
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            if let image = image{
                self.hasValueChanged = FileOperation.SaveData.image(image: image, filename: FileName.image.rawValue)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            let vc = sender as! ProfileViewController
            vc.hasDataChanged = self.hasValueChanged
            
        }
    }
}
