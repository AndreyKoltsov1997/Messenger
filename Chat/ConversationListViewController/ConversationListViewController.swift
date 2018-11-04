//
//  ConversationListViewController.swift
//  Chat
//
//  Created by Andrey Koltsov on 03/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit


class ConversationListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePicturePreview: UIImageView!
    
    @IBAction func userPicTapped(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
            self.present(vc, animated: true)
        }
    }
    
    // MARK: - Properties
    
    enum NetworkType {
        case bluetooth
        case wifi
    }
    var conversationViewController = ConversationViewController()
    private let identifier = String(describing: ConversationsListCell.self)
    private let chatSections = [Constants.ONLINE_USERS_SECTION_HEADER, Constants.OFFLINE_USERS_SECTION_HEADER]
    private var contactsInfo = [[Contact]]()
    
    private var onlineContacts = [Contact]()
    
    private var communicationService: CommunicationService  = CommunicationService(displayingName: "Andrey Koltsov")
    
    var image: UIImage? {
        didSet(newValue) {
            if let image = image {
                profilePicturePreview.image = image
            } else {
                profilePicturePreview.image =  UIImage(named: Constants.PROFILE_PICTURE_PLACEHOLDER_IMAGE_NAME)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conversationViewController.delegate = self
        configureCommunicationService()
        configureTableView()
        generateTestUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserPic()
    }
    
    private func configureCommunicationService() {
        communicationService.delegate = self
        if (!self.communicationService.online) {
            // TODO: Add options to turn the bluetooth on
            let misleadingMsg = "Bluetooth is not avaliable. Turn it on in order to improve connection."
            showNetworkSettingsAlert(message: misleadingMsg, for: .bluetooth)
        }
    }
    
    private func openBluetooth() {
        let pathToSettings = URL(string: UIApplicationOpenSettingsURLString)
        let application = UIApplication.shared
        application.open(pathToSettings!, options: [:], completionHandler: nil)
    }
    
    private func showNetworkSettingsAlert(message: String, for network: NetworkType) {
        let alert  = UIAlertController(title: "Netowrk Alert", message: message, preferredStyle: .alert)
        if (network == .bluetooth) {
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Open settings", style: .default) { action in
                self.openBluetooth()
            })
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNetworkErrorAlert(message:String) {
        let alert  = UIAlertController(title: "Netowrk Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showInviteFromUser(withPeer peer: Peer) {
        let title = peer.name + " wants to chat with you."
        let message = "Do you want to accept him?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default) { action in
            // todo: accept user here
            print("user accepted")
            self.addUserToList(userPeer: peer)
        })
        alert.addAction(UIAlertAction(title: "Decline", style: .default) { action in
            print("user declined")
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addUserToList(userPeer user: Peer) {
        let foundContact = Contact(peer: user, message: nil, date: nil, hasUnreadMessages: false, isOnline: true)
        self.onlineContacts.append(foundContact)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func loadUserPic() {
        let gcdDataManager = GCDDataManager()
        gcdDataManager.loadProfile(sender: self)
    }
    
    private func configureTableView() {
        // PARAM "bundle" is nill because we're using it within the app.
        // nibName and identifier are equals because of the file names.
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func generateTestUsers() {
        // TODO: Delete this in a feature API. It's here because I don't have time to fix this until deadline.
        let offlineUsers = [Contact]()
        contactsInfo.append(offlineUsers)
        contactsInfo.append(offlineUsers)
    }
    
    
    func findContactByPeer(_ peer: Peer) -> Contact? {
        for contact in self.onlineContacts {
            if contact.peer == peer {
                return contact
            }
        }
        return nil
    }
    
    public func configureProfile(profileInfo: ProfileModel?) {
        // TODO: Update user profile picture here
    }
    
}

// MARK: - UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        conversationViewController.contact = onlineContacts[indexPath.row]
        conversationViewController.contact.hasUnreadMessages = false
        self.navigationController?.pushViewController(conversationViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ConversationListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return chatSections[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlineContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.onlineContacts.sort(by: <)
        // guard is used for type cast of the UITableViewCell to ConversationsListCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationsListCell else {
            // nil. We have to return a strong cell in this scope. E.g.:  any default cell.
            return UITableViewCell()
        }
        let onlineContactsSection = 0
        if indexPath.section != onlineContactsSection {
            // NOTE: In this case, we're processing only online users
            return UITableViewCell()
        }
        
        let isIndexValid = onlineContacts.indices.contains(indexPath.row)
        if (isIndexValid) {
            let user = onlineContacts[indexPath.row]
            cell.name = user.name
            cell.message = user.getLastMessageFromDialog()
            cell.date = user.getLastMessageDate()
            cell.isOnline = true
            cell.backgroundColor = Constants.ONLINE_CONTACT_BACKGROUND_DEFAULT_COLOR
            
            if (user.hasUnreadMessages) {
                cell.messageTextLabel.font = UIFont.boldSystemFont(ofSize: cell.messageTextLabel.font.pointSize)
            }
        } else {
            // TODO: handle situation when "no message has been found"
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultEstimatedRowHeight = CGFloat(60)
        return defaultEstimatedRowHeight
    }
}

// MARK: - CommunicationServiceDelegate
extension ConversationListViewController: CommunicationServiceDelegate {
    func communicationService(_ communicationService: ICommunicationService, didAcceptInvite isAccepted: Bool, from peer: Peer) {
        // todo: handle invite acceptance here
        self.addUserToList(userPeer: peer)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: Peer) {
        // TODO: handle peer discovering
        self.tableView.reloadData()
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: Peer) {
        // TODO: handle peer loss
        for contact in self.onlineContacts {
            if contact.peer == peer {
                contact.isOnline = false
            }
        }
        self.onlineContacts = self.onlineContacts.filter {
            $0.peer.identifier != peer.identifier
        }

        if self.conversationViewController.viewIfLoaded?.window != nil {
            self.conversationViewController.blockUserInput()
        }
        tableView.reloadData()
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error) {
        showNetworkErrorAlert(message: "Unable to search users. Reason:" + error.localizedDescription)
    }
    
    
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveInviteFromPeer peer: Peer, invintationClosure: @escaping (Bool) -> Void) {
        // todo: handle invite receiving
        self.addUserToList(userPeer: peer)

        let title = peer.name + " wants to chat with you."
        let message = "Do you want to accept him?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default) { action in
            invintationClosure(true)
        })
        alert.addAction(UIAlertAction(title: "Decline", style: .default) { action in
            // Removing user from the list. The task said we have to initially add everyone we discovered.
            self.onlineContacts = self.onlineContacts.filter {
                $0.peer.identifier != peer.identifier
            }
            self.tableView.reloadData()
            invintationClosure(false)

        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartAdvertisingForPeers error: Error) {
        // todo: handle searching for users process
        showNetworkErrorAlert(message: "Unable to host users. Reason:" + error.localizedDescription)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: Message, from peer: Peer) {
        if let contact = self.findContactByPeer(peer) {
            contact.dialoque.append(message)
            if self.conversationViewController.viewIfLoaded?.window != nil {
                self.conversationViewController.contact.dialoque = contact.dialoque
                self.conversationViewController.updateView()
            } else {
                contact.hasUnreadMessages = true
            }
            
            tableView.reloadData()
        }
    }
    
}

// MARK: - ConversationListViewControllerDelegate
extension ConversationListViewController: ConversationListViewControllerDelegate {
    func sendMessage(_ message: Message, to peer: Peer) {
        self.communicationService.send(message, to: peer)
    }
    
    func updateDialogues(for contact: Contact) {
        for user in self.onlineContacts {
            if user == contact {
                user.dialoque = contact.dialoque
            }
        }
        self.tableView.reloadData()
    }
    
}
