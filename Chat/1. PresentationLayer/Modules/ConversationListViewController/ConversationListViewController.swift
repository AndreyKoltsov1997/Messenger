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
        if let profileViewController = presentationAssembly.profileViewController() {
            profileViewController.conversationListDelegate = self
            self.present(profileViewController, animated: true)
        }
    }
    
    // MARK: - Service Dependencies
    
    private var storage: IStorageManagerService?
    private var communicationService: CommunicationService?
    private var contactProcessingService: IContactsProcessingService?
    private var profileStorageService: IProfileStorageService?


    // MARK: - Presentation Layer Dependencies
    
    private var presentationAssembly: IPresentationAssembly!
     weak var conversationViewControllerDelegate: ConversationViewControllerDelegate?
    
    var conversationViewController: ConversationViewController?
    private let identifier = String(describing: ConversationsListCell.self)
    private let chatSections = [Constants.ONLINE_USERS_SECTION_HEADER, Constants.OFFLINE_USERS_SECTION_HEADER]

    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadProfilePicturePreview()
    }
    
    // MARK: - Private functions

    
    private func configureCommunicationService() {
       guard let communicationService = self.communicationService else {
            print("Communication service hasn't been set up yet.")
            return
        }
        communicationService.delegate = self
        if (!communicationService.isOnline) {
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
            print("user accepted")
            self.addUserToList(userPeer: peer)
        })
        alert.addAction(UIAlertAction(title: "Decline", style: .default) { action in
            print("user declined")
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addUserToList(userPeer user: Peer) {
        DispatchQueue.main.async {
            
            self.contactProcessingService?.processFoundContact(user, completion: { isContactExist, contact in
                if !isContactExist {
                    return
                }
                if let contact = contact {
                    self.processFoundLoadedContact(contact: contact)
                }
            })
            self.tableView.reloadData()
            
        }
    }
    
    private func processFoundLoadedContact(contact: Contact) {
        self.contactProcessingService?.changeContactStatus(withPeer: contact.peer, toOnlineStatus: true)
        // NOTE: If user is in the chat, block message inpit
        guard let conversationViewController = self.conversationViewController else {
            print("Unable to load conversationViewController")
            self.tableView.reloadData()
            return
        }
        if conversationViewController.viewIfLoaded?.window != nil {
            if (contact.peer != conversationViewController.contact.peer) {
                print("Idenfiriers are not equal")
                return
            }
            print("found existing contact. Inside ConvVC conversationViewController.contact.isOnline: ", conversationViewController.contact.isOnline)
            conversationViewController.unblockUserInput()
        }
    }
    
    private func loadProfilePicturePreview() {
        self.profileStorageService?.loadProfile { userName, userDescription, profilePictureBinaryData in
            if let rawProfilePicPreview = profilePictureBinaryData {
                DispatchQueue.main.async {
                     self.profilePicturePreview.image = UIImage(data: Data(referencing: rawProfilePicPreview))
                }
            }
        }
       
       
    }
    
    private func configureTableView() {
        // PARAM "bundle" is nill because we're using it within the app.
        // nibName and identifier are equals because of the file names.
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Public functions
    
    public func setupViewController(presentationAssembly: PresentationAssembly, storage: IStorageManagerService, communicationService: ICommunicationService?, contactProcessingService: IContactsProcessingService?, profileStorageService: IProfileStorageService?) {
        self.presentationAssembly = presentationAssembly
        self.storage = storage
        self.communicationService = communicationService as? CommunicationService
        self.contactProcessingService = contactProcessingService as? ContactProcessingService
        self.profileStorageService = profileStorageService
    }
    
    public func configureProfile(profileInfo: ProfileModel?) {
        // TODO: Update user profile picture here
        guard let storage = self.storage else {
            print("Storage hasn't been configured.")
            return
        }
        storage.loadProfile { name, discription, image in
            DispatchQueue.main.async {
                if let image = image as Data? {
                    self.profilePicturePreview.image = UIImage(data: image, scale: 1.0)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO: Replace it with ConversationDelegate
        let isOnline = (indexPath.section == 0)
        guard let loadingContact = self.contactProcessingService?.getContact(withIndex: indexPath.row, status: isOnline) else {
            return
        }
        if !loadingContact.isInviteConfirmed {
            guard let communicationService = self.communicationService else {
                print("Communication service hasn't been set up yet.")
                return
            }
            communicationService.sendInvite(toPeer: loadingContact.peer)
            // TODO: Change background to yellow here
            print("Invite send")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        self.conversationViewController = self.presentationAssembly.conversationViewController()
        guard let conversationViewController = conversationViewController else {
            print("ConversationViewController hasn't been found")
            return
        }
        conversationViewController.contact = loadingContact
        loadingContact.hasUnreadMessages = false // invalidating "unread" status
        conversationViewController.delegate = self
       conversationViewControllerDelegate?.loadDialoque(withContact: loadingContact)
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
        let isOnline = (section == 0)
        if let onlineContacts = contactProcessingService?.getContacts(onlineStatus: isOnline) {
            return onlineContacts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isOnline = (indexPath.section == 0)
        
        guard let contact = contactProcessingService?.getContact(withIndex: indexPath.row, status: isOnline) else {
            return UITableViewCell()
        }
        
        guard let cell = generateCell(forContact: contact) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    private func generateCell(forContact contact: Contact) -> ConversationsListCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationsListCell else {
            // nil. We have to return a strong cell in this scope. E.g.:  any default cell.
            return nil
        }
        cell.profileImage.layer.borderWidth = 2
        
        if (!contact.isInviteConfirmed) {
            let red = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            cell.profileImage.layer.borderColor = red.cgColor
        } else if contact.isOnline {
            let green = UIColor(red: 173.0/255.0, green: 255.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            cell.profileImage.layer.borderColor = green.cgColor
        } else {
            cell.profileImage.layer.borderColor = UIColor.lightGray.cgColor
        }
        cell.name = contact.name
        cell.message = contact.getLastMessageFromDialog()
        cell.date = contact.getLastMessageDate()
        cell.isOnline = contact.isOnline
        cell.backgroundColor = Constants.ONLINE_CONTACT_BACKGROUND_DEFAULT_COLOR
        if (contact.hasUnreadMessages) {
            cell.messageTextLabel.font = UIFont.boldSystemFont(ofSize: cell.messageTextLabel.font.pointSize)
        } else {
            cell.messageTextLabel.font = UIFont.systemFont(ofSize: cell.messageTextLabel.font.pointSize)
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
        // NOTE: handle invite acceptance here
        self.contactProcessingService?.changeContactStatus(withPeer: peer, toOnlineStatus: true)
        if (isAccepted) {
            DispatchQueue.main.async {
                self.contactProcessingService?.changeContactStatus(withPeer: peer, toOnlineStatus: true)
                self.tableView.reloadData()
            }
        }
        
    }
    
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: Peer) {
        // NOTE: handle peer discovering
        // NOTE: When peer is discovered, the contact will be added ...
        // ... to list. Once the dialogue has been tapped, the invite will be sent.
        DispatchQueue.main.async {
            self.contactProcessingService?.processFoundContact(peer, completion: { isContactExist, contact in
                if (!isContactExist) {
                    print("[communicationService] contact doesnt exist" )
                    return
                }
                if let contact = contact {
                    self.processFoundLoadedContact(contact: contact)
                    print("[communicationService]: process existing contact")


                }
            })
            
            self.tableView.reloadData()
        }

    
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: Peer) {
        contactProcessingService?.changeContactStatus(withPeer: peer, toOnlineStatus: false)
        contactProcessingService?.processPeerLoss(peer)
        // NOTE: If user is in the chat, block message inpit
        guard let conversationViewController = self.conversationViewController else {
            print("Unable to load conversationViewController")
            tableView.reloadData()
            return
        }
        if conversationViewController.viewIfLoaded?.window != nil {
            print("Lost contact. Inside ConvVC conversationViewController.contact.isOnline: ", conversationViewController.contact.isOnline)
            
            conversationViewController.blockUserInput()
        }
        tableView.reloadData()
    }
    
    func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error) {
        showNetworkErrorAlert(message: "Unable to search users. Reason:" + error.localizedDescription)
    }
    
    
    
    func communicationService(_ communicationService: ICommunicationService, didReceiveInviteFromPeer peer: Peer, invintationClosure: @escaping (Bool) -> Void) {
        // NOTE: handle invite receiving

        let title = peer.name + " wants to chat with you."
        let message = "Do you want to accept him?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default) { action in
            invintationClosure(true)
        })
        alert.addAction(UIAlertAction(title: "Decline", style: .default) { action in
            // Removing user from the list. The task said we have to initially add everyone we discovered.

            self.contactProcessingService?.changeContactStatus(withPeer: peer, toOnlineStatus: false)
            
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
        if let contact = contactProcessingService?.findContact(withPeer: peer) {
            contact.dialoque.append(message)
            guard let conversationViewController = self.conversationViewController else {
                // NOTE: Situation when view controller hasn't been loaded yet
                print("Unable to connect to conversationViewController.")
                contact.hasUnreadMessages = true
                tableView.reloadData()
                return
            }
            if conversationViewController.viewIfLoaded?.window != nil {
                contact.hasUnreadMessages = true
                conversationViewController.contact.dialoque = contact.dialoque
                conversationViewController.updateView()
            } else {
                contact.hasUnreadMessages = false
            }
            
            tableView.reloadData()
        }
    }
    
}

// MARK: - ConversationListViewControllerDelegate
extension ConversationListViewController: ConversationListViewControllerDelegate {
    func sendMessage(_ message: Message, to peer: Peer) {
        self.communicationService?.send(message, to: peer)
    }
    
    func updateDialogues(for contact: Contact) {
        guard let contacts = self.contactProcessingService?.getContacts() else {
            let emptyString = " "
            print("Nothing to be updated for contact", contact.name ?? emptyString)
            return
        }
        for currentContact in contacts {
            if contact == currentContact {
                contact.dialoque = currentContact.dialoque
            }
        }
        self.tableView.reloadData()
    }
    
}

// MARK: - ConversationListModelDelegate
extension ConversationListViewController: ConversationListModelDelegate {
    func updateTable() {
        self.tableView.reloadData()
    }
}

// MARK: - ConversationListDelegate
extension ConversationListViewController: ConversationListViewDelegate {
   
    func addContact(_ contect: Contact) {
        self.tableView.reloadData()
    }
    
    func updateImage(_ image: Data) {
        if let newImage = UIImage(data: image) {
           self.image = newImage
        }
    }
    
}
