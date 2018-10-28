//
//  Message.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation


//class Message {
//    let sender: Contact?
//    var text: String
//    public var isUnread = false
//    
//    init(withText text: String?, from contact: Contact?) {
//        if let text = text {
//            self.text = text
//        } else {
//            let defaultMessage = "..."
//            self.text = defaultMessage
//        }
//        self.sender = contact
//    }
//}

struct Message {
    enum `Type`: String {
        case textMessage = "TextMessage"
    }
    let identifier: String
    let text: String
    let isRecived: Bool
    let date: Date
}


