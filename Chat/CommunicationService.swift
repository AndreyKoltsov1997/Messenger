//
//  CommunicationService.swift
//  Chat
//
//  Created by Andrey Koltsov on 28/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import CoreBluetooth

class CommunicationService: NSObject, ICommunicationService {
    
    var delegate: CommunicationServiceDelegate?
    var online: Bool = true // TODO: change value depend on bluetooth / WiFi accessability
    
    // Multipeer Connectivity Properties
    
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession!
    let serviceType = "tinkoff-chat"
    var activePeers: [Peer] = []
    
    // Bluetooth Manager
    var bluetoothManager: CBCentralManager!
    var isBluetoothAvaliable: Bool = false
    
    let discoveryInfo: [String: String]!
    // @serviceAdvertiser publishes invitations to join self as a host
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    // @serviceBrowser searches for services provided by nearby devices
    var serviceBrowser: MCNearbyServiceBrowser!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    lazy var session : MCSession! = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    init(displayingName name: String) {

        self.online = false
        self.discoveryInfo = ["userName": name]
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: self.discoveryInfo, serviceType: self.serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.serviceType)
        super.init()
        
        self.configureNetworkManagers()

        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
        
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    private func configureNetworkManagers() {
        self.bluetoothManager = CBCentralManager()
        bluetoothManager.delegate = self
        // TODO: check bluetooth connection here
    }
    
    public func pauseSearchingNewUsers() {
        self.serviceBrowser.stopBrowsingForPeers();
    }
    
    public func sendInvite(toPeer peer: Peer) {
        self.serviceBrowser.invitePeer(peer.identifier, to: session, withContext: nil, timeout: 300)
    }
    
    func send(_ message: Message, to peer: Peer) {
        do {
            let jsonEncodedMessage = ["eventType": "TextMessage", "messageId": message.identifier, "text": message.text]
            let jsonData = try JSONSerialization.data(withJSONObject: jsonEncodedMessage, options: .prettyPrinted)
         
            if !self.activePeers.contains(peer) {
                print("User hasn't been found")
                return
            }
            
            try session.send(jsonData, toPeers: [peer.identifier], with: .reliable)
        } catch {
            print("Unable to send JSON, reason:", error.localizedDescription)
        }
    }
    
    func getPeerByID (_ lostPeerID: MCPeerID) -> Peer {
        var lostPeer = Peer(name: lostPeerID.displayName, id: lostPeerID)
        for user in self.activePeers {
            if user  == lostPeer {
                lostPeer = user
            }
        }
        return lostPeer
    }
  
    
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension CommunicationService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let inviter = Peer(name: peerID.displayName, id: peerID)

        if session.connectedPeers.contains(peerID) {
            // TODO: Restore contact state to "online" here
            print("MCNearbyServiceAdvertiser: found existing peer")
            return
        }
        

        self.delegate?.communicationService(self, didReceiveInviteFromPeer: inviter) { [weak self] isAccepted in
            if (isAccepted) {
                // NOTE: Accepting invite from the user
                let newPeer = Peer(name: peerID.displayName, id: peerID)
                self?.activePeers.append(newPeer)
            }
            invitationHandler(isAccepted, self?.session)
        }
    }
    
}

// MARK: - MCSessionDelegate
extension CommunicationService: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // TODO: impliment peer change state
        let peer = Peer(name: peerID.displayName, id: peerID)
        if (self.activePeers.contains(peer)) {
            print("found existing peer")
            delegate?.communicationService(self, didFoundPeer: peer)
            // NOTE: pear already exist. Return.
            return
        }
        let isConfirmed = (state.rawValue != 0)
        if (isConfirmed) {
            delegate?.communicationService(self, didAcceptInvite: isConfirmed, from: peer)
            print("active peers, session:", self.activePeers)
        }
      
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // TODO: impliment receiving data from peer
        do {
            let rawJsonMessage = try JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
            let decodedMessage = Message(identifier: rawJsonMessage["messageId"]!, text: rawJsonMessage["text"]!, isRecived: true, date: Date())
            
            print(decodedMessage)
            DispatchQueue.main.async {
                self.delegate?.communicationService(self, didReceiveMessage: decodedMessage, from: self.getPeerByID(peerID))
            }
        } catch {
            print("Unable to process recieved data")
            return
        }
        
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - MCNearbyServiceBrowserDelegate
extension CommunicationService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // NOTE: impliment peer discovering behaviour
        let peer = Peer(name: peerID.displayName, id: peerID)
        delegate?.communicationService(self, didFoundPeer: peer)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // NOTE: impliment peer loss behavior
        let lostPeer = Peer(name: peerID.displayName, id: peerID)
        if activePeers.contains(lostPeer) {
            // NOTE: Peer is in the contact list
            self.delegate?.communicationService(self, didLostPeer: self.getPeerByID(peerID))
        } else {
            // NOTE: Peer is not in the contact list
            self.delegate?.communicationService(self, didLostPeer: Peer(name: peerID.displayName, id: peerID))

        }
    }
    
}

// MARK: - CBCentralManagerDelegate
extension CommunicationService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.isBluetoothAvaliable = true
            break
        default:
            self.isBluetoothAvaliable = false
            break
        }
    }
}
