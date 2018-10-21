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
    let concurrentQueue = DispatchQueue(label: "gcd.concurrent", attributes: .concurrent)
    
    var hasValueChanged: Bool? = true
    
    var profileInfo: ProfileInfo?
    
    func main(sender: Any, operation: OperaionType, profile: [String: Any]? = nil) {
        switch operation {
        case .save:
            self.saveProfile(sender: sender)
        case .load:
            print("Loading data...")
            //loadProfile(sender: sender, type: type)
        }
    }
    
    private func loadProfile(sender: Any, type: SenderType) {
        let group = DispatchGroup()
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.userName = FileOperation.load.text(filename: FileName.username.rawValue)
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.discription = FileOperation.load.text(filename: FileName.information.rawValue)
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            self.profileInfo?.profilePicture = FileOperation.load.image(filename: FileName.image.rawValue)
            //            self.image = FileOperation.load.image(filename: FileName.image.rawValue)
            group.leave()
        }
        
        group.notify(queue: .main) {
            switch type {
            case .profileViewController:
                let vc = sender as! ProfileViewController
                
                
                if let profileInfo = self.profileInfo {
                    vc.configureProfile(profileInfo: profileInfo)
                } else {
                    print("User data hasn't changed yet.")
                }
                
            case .editProfileViewController:
                break
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
            if username != nil {
                self.hasValueChanged = FileOperation.save.text(text: username!, filename: FileName.username.rawValue)
            }
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            if information != nil {
                self.hasValueChanged = FileOperation.save.text(text: information!, filename: FileName.information.rawValue)
            }
            group.leave()
        }
        
        group.enter()
        concurrentQueue.async {
            if image != nil {
                self.hasValueChanged = FileOperation.save.image(image: image!, filename: FileName.image.rawValue)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            let vc = sender as! ProfileViewController
            vc.hasDataChanged = self.hasValueChanged
            
        }
    }
}
