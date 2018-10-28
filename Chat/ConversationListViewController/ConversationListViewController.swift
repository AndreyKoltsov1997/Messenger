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
            let misleadingMsg = "Bluetooth is not avaliable. Couldn't scan for users."
            showNetworkErrorAlert(message: misleadingMsg)
        }
    }
    
    private func showNetworkErrorAlert(message:String) {
        let alert  = UIAlertController(title: "Netowrk Error", message: message, preferredStyle: .alert)
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
        self.tableView.reloadData()
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
        contactsInfo.append(generateOnlineUsers())
        contactsInfo.append(generateOfflineUsers())
    }
    
    private func generateOfflineUsers() -> [Contact] {
        var offlineUsers = [Contact]()
//        offlineUsers.append(Contact(name: "John Doe", message: "Let's hang out!", date: Date(), hasUnreadMessages: false, isOnline: false))
//        offlineUsers.append(Contact(name: "Terry Williams", message: "I'm going to SF tonights. Will you come?", date: Date(timeIntervalSinceNow: 2222), hasUnreadMessages: true, isOnline: false))
//        offlineUsers.append(Contact(name: "Alba Hetrow", message: "I've been trying to get into FaceBook lately.", date: Date(timeIntervalSince1970: 33333333), hasUnreadMessages: false, isOnline: false))
//        offlineUsers.append(Contact(name: "Gokzu Guz", message: "", date: Date(), hasUnreadMessages: false, isOnline: false))
//        offlineUsers.append(Contact(name: "Garry Rosherd", message: "That steak we bought yesterday wasn't that great..", date: Date(timeIntervalSinceNow: 44444), hasUnreadMessages: false, isOnline: false))
//
//        offlineUsers.append(Contact(name: "Alexey Kushirov", message: "There's a deadline approaching. Hurry up!", date: Date(timeIntervalSince1970: 55555), hasUnreadMessages: true, isOnline: false))
//        offlineUsers.append(Contact(name: "Herby Authrey", message: "have you done your homework?", date: Date(), hasUnreadMessages: true, isOnline: false))
//        offlineUsers.append(Contact(name: "Donald Trump", message: "Do not make memes of me.", date: Date(timeIntervalSince1970: 666666), hasUnreadMessages: false, isOnline: false))
//        offlineUsers.append(Contact(name: "Harley Davidson", message: "I like cars better.", date: Date(), hasUnreadMessages: true, isOnline: false))
//        offlineUsers.append(Contact(name: "David Russie", message: "Yes, Paris is an amazing city.", date: Date(timeIntervalSince1970: 7777), hasUnreadMessages: false, isOnline: false))
        return offlineUsers
    }
    
    private func generateOnlineUsers() -> [Contact] {
        var onlineUsers = [Contact]();
//        onlineUsers.append(Contact(name: "Mark Nerrow", message: "", date: Date(), hasUnreadMessages: true, isOnline: true))
//        onlineUsers.append(Contact(name: "Anastasia Tssvetkova", message: "DO NOT send me photos like this. Ewww..", date: Date(timeIntervalSince1970: 88888), hasUnreadMessages: false, isOnline: true))
//        onlineUsers.append(Contact(name: "David Rasberry", message: "Why is Nastya so pissed off?", date: Date(), hasUnreadMessages: true, isOnline: true))
//        onlineUsers.append(Contact(name: "Anatoly Nestvetay", message: "LMAO I've seen that picture you've sent to Anastatia", date: Date(timeIntervalSince1970: 8888), hasUnreadMessages: false, isOnline: true))
//        onlineUsers.append(Contact(name: "Ivan Orlandov", message: "Why is everybody discussing a picture of a naked man?", date: Date(), hasUnreadMessages: false, isOnline: true))
//
//        onlineUsers.append(Contact(name: "David Johnson", message: "What's up with the visa?", date: Date(), hasUnreadMessages: false, isOnline: true))
//        onlineUsers.append((Contact(name: "Katya Jurkina", message: "Yes!!! Would be fun.", date: Date(timeIntervalSince1970: 77777), hasUnreadMessages: true, isOnline: true)))
//        onlineUsers.append(Contact(name: "Aubrey Gragham", message: "You should listen to a better music, man.", date: Date(timeIntervalSince1970: 39393939), hasUnreadMessages: false, isOnline: true))
//        onlineUsers.append((Contact(name: "Barack Fedorov", message: "Are u ok?", date: Date(), hasUnreadMessages: false, isOnline: true)))
//        onlineUsers.append(Contact(name: "Abel Koltsov", message: "Dude, I'm still waiting.", date: Date(), hasUnreadMessages: true, isOnline: true))
        return onlineUsers
    }
    
   
    
    public func configureProfile(profileInfo: ProfileInfo?) {
        self.image = profileInfo?.profilePicture
       // activityIndicator.stopAnimating()
    }

}

// MARK: - UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversationViewController = ConversationViewController()
        conversationViewController.delegate = self
        conversationViewController.contact = onlineContacts[indexPath.row]
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
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: Peer) {
        // TODO: handle peer loss
        self.onlineContacts = self.onlineContacts.filter {
            $0.peer == peer
        }
        tableView.reloadData()
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error) {
        // todo: handle error with start browsing
    }
    
    
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveInviteFromPeer peer: Peer, invintationClosure: @escaping (Bool) -> Void) {
        // todo: handle invite receiving
        let title = peer.name + " wants to chat with you."
        let message = "Do you want to accept him?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default) { action in
  
            self.addUserToList(userPeer: peer)
            invintationClosure(true)
        })
        alert.addAction(UIAlertAction(title: "Decline", style: .default) { action in
            print("user declined")
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartAdvertisingForPeers error: Error) {
        // todo: handle searching for users process
    }
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: Message, from peer: Peer) {
        // TODO: handle message receiving process
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
