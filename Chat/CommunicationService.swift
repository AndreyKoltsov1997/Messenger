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
    var activePeers: [String: MCPeerID] = [:]
    
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
    
    func send(_ message: Message, to peer: Peer) {}
    
   
    
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension CommunicationService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // TODO: HANDLE RECIVING INVITE FROM THE USER
        print("received an nvite from peer: ", peerID.displayName)
        let inviter = Peer(name: peerID.displayName)
        self.delegate?.communicationService(self, didReceiveInviteFromPeer: inviter, invintationClosure: ({ isAccepted in
            print("Is invite accepted: ", isAccepted)
            if isAccepted {
                
            }
        }))
    }
    
}

// MARK: - MCSessionDelegate
extension CommunicationService: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // TODO: impliment peer change state
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // TODO: impliment receiving data from peer
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // todo: impliment receiving data from stream
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // todo: impliment start receiving resources
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // todo: imppliment finish receiving resources
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension CommunicationService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // TODO: impliment peer discovering behaviour
        browser.invitePeer(peerID, to: self.session, withContext: self.serviceType.data(using: .utf8), timeout: 600)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // TODO: impliment peer loss behavior
//        let lostPeer = Peer(name: lo)
//        self.delegate?.communicationService(self, didLostPeer: pe)
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
