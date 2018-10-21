//
//  SaveViaOperations.swift
//  Chat
//
//  Created by Andrey Koltsov on 21/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class OperationDataManager {
        
    let userNameSavingOperation = UsernameSavingOperation()
    let discriptionSavingOperation = DiscriptionSavingOperation()
    let imageSavingOperation = ImageSavingOperation()
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        let AMOUNT_OF_USER_PROPERTIES = 3
        queue.maxConcurrentOperationCount = AMOUNT_OF_USER_PROPERTIES
        return queue
    }()
    
    
    internal func saveProfile(sender: UIViewController, profile: ProfileInfo) {
        userNameSavingOperation.userName = profile.userName
        discriptionSavingOperation.discription = profile.discription
        imageSavingOperation.image = profile.profilePicture
        
        let updatingDataOperationComplete = BlockOperation {
            let distinationViewController = sender as! ProfileViewController
            distinationViewController.hasDataChanged = true
        }
        
        updatingDataOperationComplete.addDependency(userNameSavingOperation)
        updatingDataOperationComplete.addDependency(discriptionSavingOperation)
        updatingDataOperationComplete.addDependency(imageSavingOperation)
        operationQueue.addOperations([userNameSavingOperation, discriptionSavingOperation, imageSavingOperation], waitUntilFinished: false)
        
        OperationQueue.main.addOperation(updatingDataOperationComplete)
    }
    
}

