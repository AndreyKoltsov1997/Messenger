//
//  ConversationListModel.swift
//  Chat
//
//  Created by Andrey Koltsov on 06/11/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import CoreData

enum NetworkType {
    case bluetooth
    case wifi
}

class ConversationListModel {
    
    // NOTE: Identifier factory for Contact
    private static var identifierFactory = 0
    public static func getUniqueIdentifier() -> String {
        identifierFactory += 1
        return String(ConversationListModel.identifierFactory)
    }
    
    // MARK: - Properties
    weak var delegate: ConversationListModelDelegate?
    
    public var contactsInfo = [String: Peer]()
    
    public var contacts = [ContactCD]() {
        didSet {
            delegate?.updateTable()
        }
    }
    
    private var connectedPeers = [Peer]()
    
    
    // MARK: - Constructor
    init() {
        // loadDialogues()
    }
    
    // MARK: - Private methods
    
    private func loadDialogues() {
        //try? contactsFetchResultController.performFetch()
    }
    // MARK: - Public methods
    
    public func processFoundPeer(_ peer: Peer) {
        if !self.isPeerExist(peer) {
            let foundContact = Contact(peer: peer, message: nil, date: Date(), hasUnreadMessages: false, isOnline: true)
            foundContact.isOnline = true
            foundContact.name = peer.name
            StorageCoreData.saveContact(foundContact) { [weak self] isSaveSuccess in
                guard let isSaveSuccess = isSaveSuccess else {
                    return
                }
                if (isSaveSuccess) {
                    self?.contactsInfo.updateValue(peer, forKey: foundContact.getIdentifier())

                }
                
            }
            
        } else {
            // NOTE: Updating user online status
            if let contactID = self.findContactID(withPeer: peer) {
                let isOnline = true
                StorageCoreData.changeContactStatus(withID: contactID, toStatus: isOnline)

            }
        }
        
        
        
    }
    
    public func isPeerExist(_ peer: Peer) -> Bool {
        return self.contactsInfo.values.contains(peer)
    }
    
    public func isContactExist(withID id: String) -> Bool {
        guard let contacts = StorageCoreData.getContacts() else {
            return false
        }
        return contacts.contains(where: {$0.id == id})
    }
    
    public func findContactID(withPeer peer: Peer) -> String? {
        let storingContacts = self.contactsInfo.keys
        for contact in storingContacts {
            if self.contactsInfo[contact] == peer {
                return contact
            }
        }
        return nil
    }
    
    public func getPeer(for contact: ContactCD) -> Peer? {
        guard let contactID = contact.id else {
            return nil
        }
        guard let peer = self.contactsInfo[contactID] else {
            return nil
        }
        return peer
    }
    
    public func getContacts(onlineStatus isOnline: Bool) -> [ContactCD]? {
        
        var requiredContacts = [ContactCD]()
        guard let existingContacts = StorageCoreData.getContacts() else {
            return nil
        }
        for contact in existingContacts {
            if contact.isOnline == isOnline {
                requiredContacts.append(contact)
            }
        }
        return requiredContacts
    }
    
    public func getContact(withIndex index: Int, status isOnline: Bool) -> ContactCD? {
        // TODO: Impliment sorting
        // self.contacts.sort(by: <)
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
        guard let contactID = self.findContactID(withPeer: peer) else {
            print("Unable to find contact with peer", peer)
            return
        }
        // TODO: Impliment saving into history
        StorageCoreData.deleteContact(withID: contactID)
    }
    
    public func changeContactStatus(withPeer peer: Peer, toOnlineStatus isOnline: Bool) {
        // TODO: Impliment method
        guard let contactID = self.findContactID(withPeer: peer) else {
            // NOTE: Means contact doesnt exist
            return
        }
        StorageCoreData.changeContactStatus(withID: contactID, toStatus: isOnline)
    }
    
}
