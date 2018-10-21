//
//  SaveViaOperations.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class OperationDataManager {
    
   // var isSave: Bool? = true
    
    let userNameSavingOperation = UsernameSavingOperation()
    let discriptionSavingOperation = DiscriptionSavingOperation()
    let imageSavingOperation = ImageSavingOperation()
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    
    
    internal func saveProfile(sender: Any, profile: ProfileInfo) {
        userNameSavingOperation.userName = profile.userName
        discriptionSavingOperation.discription = profile.discription
        imageSavingOperation.image = profile.profilePicture
        
        let updatingDataOperationComplete = BlockOperation {
            let vc = sender as! ProfileViewController
            vc.hasDataChanged = true
        }
        
        updatingDataOperationComplete.addDependency(userNameSavingOperation)
        updatingDataOperationComplete.addDependency(discriptionSavingOperation)
        updatingDataOperationComplete.addDependency(imageSavingOperation)
        
        operationQueue.addOperations([userNameSavingOperation, discriptionSavingOperation, imageSavingOperation], waitUntilFinished: false)
        
        OperationQueue.main.addOperation(updatingDataOperationComplete)
    }
    
}

