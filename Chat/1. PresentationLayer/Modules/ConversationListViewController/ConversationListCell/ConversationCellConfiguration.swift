//
//  ConversationCellConfiguration.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration: class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var isOnline: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}
