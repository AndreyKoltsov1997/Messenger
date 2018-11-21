//
//  CommunicationServiceDelegate.swift
//  Chat
//
//  Created by Andrey Koltsov on 27/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

protocol CommunicationServiceDelegate: class {
    // Session
    func communicationService(_ communicationService: ICommunicationService, didAcceptInvite isAccepted: Bool, from peer: Peer)
    
    /// Browsing
    func communicationService(_ communicationService: ICommunicationService,
                              didFoundPeer peer: Peer)
    func communicationService(_ communicationService: ICommunicationService,
                              didLostPeer peer: Peer)
    func communicationService(_ communicationService: ICommunicationService,
                              didNotStartBrowsingForPeers error: Error)
    /// Advertising
    func communicationService(_ communicationService: ICommunicationService,
                              didReceiveInviteFromPeer peer: Peer,
                              invintationClosure: @escaping (Bool) -> Void)
    func communicationService(_ communicationService: ICommunicationService,
                              didNotStartAdvertisingForPeers error: Error)
    /// Messages
    func communicationService(_ communicationService: ICommunicationService,
                              didReceiveMessage message: Message,
                              from peer: Peer)
}
