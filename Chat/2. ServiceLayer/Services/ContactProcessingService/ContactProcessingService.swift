//
//  ContactProcessingService.swift
//  Chat
//
//  Created by Andrey Koltsov on 06/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation

enum NetworkType {
    case bluetooth
    case wifi
}

protocol IContactsProcessingService {
    
    // NOTE: Operations with contacts
    func isContactExist(withPeer peer: Peer) -> Bool
    func findContact(withPeer peer: Peer) -> Contact?
    func changeContactStatus(withPeer peer: Peer, toOnlineStatus isOnline: Bool)

    func getContact(withIndex index: Int, status isOnline: Bool) -> Contact?
    func getContacts() -> [Contact]
    func getContacts(onlineStatus isOnline: Bool) -> [Contact]?
    
    // NOTE: Handle peer discovery / loss
    func processFoundContact(_ peer: Peer, completion: @escaping (_ isExist: Bool, _ contact: Contact?) -> Void)
    func connectUser(withPeer peer: Peer)
    func processPeerLoss(_ peer: Peer)
}


class ContactProcessingService {
    
    weak var delegate: ConversationListModelDelegate?

    public var contacts = [Contact]() {
        didSet {
            delegate?.updateTable()
        }
    }
    private var connectedPeers = [Peer]()

    
}

// MARK: - IContactsProcessingService
extension ContactProcessingService: IContactsProcessingService {
    func getContacts() -> [Contact] {
        return self.contacts
    }
    
    public func processFoundContact(_ peer: Peer, completion: @escaping (_ isExist: Bool, _ contact: Contact?) -> Void) {
        let foundContact = Contact(peer: peer, message: nil, date: nil, hasUnreadMessages: false, isOnline: true)
        let isContactExist = self.contacts.contains(where: { $0.peer?.identifier == peer.identifier })
        
        if !isContactExist {
            completion(false, nil)
            self.contacts.append(foundContact)
        } else {
            completion(true, foundContact)
            changeContactStatus(withPeer: peer, toOnlineStatus: true)
        }
        
    }
    
    public func isContactExist(withPeer peer: Peer) -> Bool {
        return self.contacts.contains(where: { $0.peer?.identifier == peer.identifier })
    }
    
    public func findContact(withPeer peer: Peer) -> Contact? {
        for contact in self.contacts {
            if contact.peer == peer {
                return contact
            }
        }
        return nil
    }
    
    public func connectUser(withPeer peer: Peer) {
        connectedPeers.append(peer)
    }
    
    public func getContacts(onlineStatus isOnline: Bool) -> [Contact]? {
        var requiredContacts = [Contact]()
        for contact in self.contacts {
            if contact.isOnline == isOnline {
                requiredContacts.append(contact)
            }
        }
        return requiredContacts
    }
    
    public func getContact(withIndex index: Int, status isOnline: Bool) -> Contact? {
        self.contacts.sort(by: <)
        guard let requiredContacts = self.getContacts(onlineStatus: isOnline) else {
            return nil
        }
        let isIndexValid = requiredContacts.indices.contains(index)
        if (!isIndexValid) {
            return nil
        }
        return requiredContacts[index]
    }
    
    public func processPeerLoss(_ peer: Peer) {
        // NOTE: Possible problemms with tableView reloading here
        for contact in self.contacts {
            if contact.peer == peer {
                contact.isOnline = false
            }
        }
    }
    
    public func changeContactStatus(withPeer peer: Peer, toOnlineStatus isOnline: Bool) {
        for contact in self.contacts {
            if contact.peer == peer {
                contact.isOnline = isOnline
                contact.isInviteConfirmed = true
            }
        }
    }
}
