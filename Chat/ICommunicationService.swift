//
//  ICommunicationService.swift
//  Chat
//
//  Created by Andrey Koltsov on 27/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol ICommunicationService  {
    var delegate: CommunicationServiceDelegate? { get set }
    /// Онлайн/Не онлайн
    var online: Bool { get set }
    /// Отправляет сообщение участнику
    func send(_ message: Message, to peer: Peer)
}
