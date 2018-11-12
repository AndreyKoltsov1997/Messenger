//
//  ConversationListViewController.swift
//  Chat
//
//  Created by Andrey Koltsov on 03/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit
import CoreData

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
    
    private lazy var conversationList = ConversationListModel()
    public func getConversationListModel() -> ConversationListModel {
        return conversationList
    }
    
    lazy var contactsFetchResultController: NSFetchedResultsController<ContactCD> = {
        let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.resultType = .managedObjectResultType
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: StorageCoreData.context, sectionNameKeyPath: nil, cacheName: nil)
         controller.delegate = self
        return controller
    }()
    
    lazy var conversationFetchResultController: NSFetchedResultsController<Conversation> = {
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        fetchRequest.sortDescriptors = StorageCoreData.conversationSortDiscriptors
        fetchRequest.resultType = .managedObjectResultType
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: StorageCoreData.context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
     weak var conversationViewControllerDelegate: ConversationViewControllerDelegate?
    
    var conversationViewController = ConversationViewController()
    private let identifier = String(describing: ConversationsListCell.self)
    private let chatSections = [Constants.ONLINE_USERS_SECTION_HEADER, Constants.OFFLINE_USERS_SECTION_HEADER]

    
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
        self.configureFRCs()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserPic()
    }
    
    private func configureFRCs() {
        do {
            try contactsFetchResultController.performFetch()
            try conversationFetchResultController.performFetch()
        } catch {
            print("An error has occured while configuring fetch result controllers:", error.localizedDescription)
        }
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
            self.conversationList.processFoundPeer(user)

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

    
    public func configureProfile(profileInfo: ProfileModel?) {
        // TODO: Update user profile picture here
        CoreDataStorageSQLite.loadProfile { name, discription, image in
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
        guard let loadingContact = self.conversationList.getContact(withIndex: indexPath.row, status: isOnline) else {
            return
        }
        if !loadingContact.isInviteConfirmed {
            guard let distinationPeer = self.conversationList.getPeer(for: loadingContact) else {
                print("Peer hasn't been found for contacts \(loadingContact.name)")
                return 
            }
            self.communicationService.sendInvite(toPeer: distinationPeer)
            // TODO: Change background to yellow here
            print("Invite send")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }
        conversationViewController.contact = loadingContact
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
        guard let amountOfSectionsInDataBase = conversationFetchResultController.sections else  {
            print("Unable to find any sections within conversation DB table.")
            return 0
        }
        if let onlineContacts = conversationList.getContacts(onlineStatus: isOnline) {
            return onlineContacts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isOnline = (indexPath.section == 0)
        
        try? conversationFetchResultController.performFetch()
        
        // TODO: replace with function, isOnline passing as a parameter
        guard let contacts = StorageCoreData.getContacts() else {
            return UITableViewCell()
        }
        guard let contact = conversationList.getContact(withIndex: indexPath.row, status: isOnline) else {
            return UITableViewCell()
        }
        
        guard let cell = generateCell(forContact: contacts[0]) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    private func generateCell(forContact contact: ContactCD) -> ConversationsListCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationsListCell else {
            // nil. We have to return a strong cell in this scope. E.g.:  any default cell.
            return nil
        }
        cell.profileImage.layer.borderWidth = 2
        
        if (!contact.isInviteConfirmed) {
            let yellow = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            cell.profileImage.layer.borderColor = yellow.cgColor
        } else if contact.isOnline {
            let green = UIColor(red: 173.0/255.0, green: 255.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            cell.profileImage.layer.borderColor = green.cgColor
        } else {
            cell.profileImage.layer.borderColor = UIColor.lightGray.cgColor
        }
        cell.name = contact.name
        cell.message = "Test message (HARD CODED)"
        // TODO: replace hard-coded messages
        cell.date = Date()
        cell.isOnline = contact.isOnline
        // TODO: Add custom color for online contacts cell background
        cell.backgroundColor = Constants.ONLINE_CONTACT_BACKGROUND_DEFAULT_COLOR
       cell.messageTextLabel.font = UIFont.boldSystemFont(ofSize: cell.messageTextLabel.font.pointSize)
        // TODO: Impliment logic for unread messages
//        if (contact.hasUnreadMessages) {
//            cell.messageTextLabel.font = UIFont.boldSystemFont(ofSize: cell.messageTextLabel.font.pointSize)
//        }
        

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
        if (isAccepted) {
            DispatchQueue.main.async {
                self.conversationList.changeContactStatus(withPeer: peer, toOnlineStatus: true)
            }
        }
        
    }
    
    func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: Peer) {
        // NOTE: handle peer discovering
        // NOTE: When peer is discovered, the contact will be added ...
        // ... to list. Once the dialogue has been tapped, the invite will be sent.
        DispatchQueue.main.async {
            self.conversationList.processFoundPeer(peer)
            
            self.tableView.reloadData()
        }
    
    }
    
    func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: Peer) {
        conversationList.processPeerLoss(peer)
        // NOTE: If user is in the chat, block message inpit
        if self.conversationViewController.viewIfLoaded?.window != nil {
            self.conversationViewController.blockUserInput()
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

            self.self.conversationList.changeContactStatus(withPeer: peer, toOnlineStatus: false)
            
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
        if let contactID = conversationList.findContactID(withPeer: peer) {
            guard let contact = StorageCoreData.getContact(withID: contactID) else {
                print("No contact has been found with displaying name \(peer.name)")
                return
            }
            StorageCoreData.saveMessage(message, withIn: contact.conversation)
            if self.conversationViewController.viewIfLoaded?.window != nil {
                // TODO: Handle situation when screen is displaying - set message as "read"
                self.conversationViewController.updateView()
            } else {
                // NOTE: set message as "unread"
                contact.conversation.hasUnreadMessages = true
            }
            
            tableView.reloadData()
        }
    }
    
}

// MARK: - ConversationListViewControllerDelegate
extension ConversationListViewController: ConversationListViewControllerDelegate {
    func sendMessage(_ message: MessageCD, to peer: Peer) {
        self.communicationService.send(message, to: peer)
    }
    
    func updateDialogues(for contact: ContactCD) {
        for currentContact in self.conversationList.contacts {
            if contact == currentContact {
                contact.conversation.messages = currentContact.conversation.messages
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

extension ConversationListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = indexPath {
            switch type {
            case .update:
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
              //  self.tableView.reloadData()
            case .move:
                guard let newIndexPath = newIndexPath else { break }
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
                break
            case .insert:
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                break
            case .delete:
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                break
            default:
                break
            }
            self.tableView.reloadData()
        } else {
            if let newIndexPath = newIndexPath {
                switch type {
                case .insert:
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                    break
                default:
                    break
                }
            }
        }
        
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
