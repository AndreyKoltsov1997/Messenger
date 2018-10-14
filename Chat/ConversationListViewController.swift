//
//  ConversationListViewController.swift
//  Chat
//
//  Created by Andrey Koltsov on 03/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

protocol ConversationListViewControllerDelegate: class {
    func setChildViewControllerTitle(_ title: String)
}

class ConversationListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func userPicTapped(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
            // получили доступ к storyboard, а точнее - к его initial VC
            self.present(vc, animated: true)
        }
        
    }
    
    // MARK: - Properties
    public weak var delegate: ConversationListViewControllerDelegate?
    private let identifier = String(describing: ConversationsListCell.self)
    private let chatSections = [Constants.ONLINE_USERS_SECTION_HEADER, Constants.OFFLINE_USERS_SECTION_HEADER]
    
    private var contactsInfo = [[Contact]]()
    // NOTE: PARAM @User - encapsulates default user info
    private let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        generateTestUsers()
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
        
        // NOTE: Generating offline contacts
        contactsInfo.append(generateOnlineUsers())
        contactsInfo.append(generateOfflineUsers())
        
        // NOTE: Generating online contacts

    }
    
    private func generateOfflineUsers() -> [Contact] {
        var offlineUsers = [Contact]()
        offlineUsers.append(Contact(name: "John Doe", message: "Let's hang out!", date: Date(), hasUnreadMessages: false, isOnline: false))
        offlineUsers.append(Contact(name: "Terry Williams", message: "I'm going to SF tonights. Will you come?", date: Date(timeIntervalSinceNow: 2222), hasUnreadMessages: true, isOnline: false))
        offlineUsers.append(Contact(name: "Alba Hetrow", message: "I've been trying to get into FaceBook lately.", date: Date(timeIntervalSince1970: 33333333), hasUnreadMessages: false, isOnline: false))
        offlineUsers.append(Contact(name: "Gokzu Guz", message: "I want to surf tommorow.", date: Date(), hasUnreadMessages: false, isOnline: false))
        offlineUsers.append(Contact(name: "Garry Rosherd", message: "That steak we bought yesterday wasn't that great..", date: Date(timeIntervalSinceNow: 44444), hasUnreadMessages: false, isOnline: false))
        
        offlineUsers.append(Contact(name: "Alexey Kushirov", message: "THere's a deadline approaching. Hurry up!", date: Date(timeIntervalSince1970: 55555), hasUnreadMessages: true, isOnline: false))
        offlineUsers.append(Contact(name: "Herby Authrey", message: "have you done your homework?", date: Date(), hasUnreadMessages: true, isOnline: false))
        offlineUsers.append(Contact(name: "Donald Trump", message: "Do not make memes of me.", date: Date(timeIntervalSince1970: 666666), hasUnreadMessages: false, isOnline: false))
        offlineUsers.append(Contact(name: "Harley Davidson", message: "I like cars better.", date: Date(), hasUnreadMessages: true, isOnline: false))
        offlineUsers.append(Contact(name: "David Russie", message: "Yes, Paris is an amazing city.", date: Date(timeIntervalSince1970: 7777), hasUnreadMessages: false, isOnline: false))
        return offlineUsers
    }
    
    private func generateOnlineUsers() -> [Contact] {
        var onlineUsers = [Contact]();
        onlineUsers.append(Contact(name: "Mark Nerrow", message: "What? Not even thought about it", date: Date(), hasUnreadMessages: true, isOnline: true))
        onlineUsers.append(Contact(name: "Anastasia Tssvetkova", message: "DO NOT send me photos like this. Ewww..", date: Date(timeIntervalSince1970: 88888), hasUnreadMessages: false, isOnline: true))
        onlineUsers.append(Contact(name: "David Rasberry", message: "Why is Nastya so pissed off?", date: Date(), hasUnreadMessages: true, isOnline: true))
        onlineUsers.append(Contact(name: "Anatoly Nestvetay", message: "LMAO I've seen that picture you've sent to Anastatia", date: Date(timeIntervalSince1970: 8888), hasUnreadMessages: false, isOnline: true))
        onlineUsers.append(Contact(name: "Ivan Orlandov", message: "Why is everybody discussing a picture of a naked man?", date: Date(), hasUnreadMessages: false, isOnline: true))
        
        onlineUsers.append(Contact(name: "David Johnson", message: "What's up with the visa?", date: Date(), hasUnreadMessages: false, isOnline: true))
        onlineUsers.append((Contact(name: "Katya Jurkina", message: "Yes!!! Would be fun.", date: Date(timeIntervalSince1970: 77777), hasUnreadMessages: true, isOnline: true)))
        onlineUsers.append(Contact(name: "Aubrey Gragham", message: "You should listen to a better music, man.", date: Date(timeIntervalSince1970: 39393939), hasUnreadMessages: false, isOnline: true))
        onlineUsers.append((Contact(name: "Barack Fedorov", message: "Are u ok?", date: Date(), hasUnreadMessages: false, isOnline: true)))
        onlineUsers.append(Contact(name: "Abel Koltsov", message: "Dude, I'm still waiting.", date: Date(), hasUnreadMessages: true, isOnline: true))
        return onlineUsers
    }
    
    private func resetCellData(_ cell: ConversationsListCell) {
        cell.usernameLabel.text = ""
        cell.messageTextLabel.text = ""
        cell.messageDateLabel.text = ""
    }

    
    
}

// MARK: - UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // Когда ячейка нажата, нам нужно перейти на новый viewController;
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversationViewController = ConversationViewController()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ConversationsListCell else {
            // nil. We have to return a strong cell in this scope. E.g.:  any default cell.
            return
        }
        // TODO: Add name delegation here
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
        return contactsInfo[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // guard is used for type cast of the UITableViewCell to ConversationsListCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationsListCell else {
            // nil. We have to return a strong cell in this scope. E.g.:  any default cell.
            return UITableViewCell()
        }
        
        let processingCellInfo = contactsInfo[indexPath.section][indexPath.row]
        cell.name = processingCellInfo.name
        cell.message = processingCellInfo.message
        cell.isOnline = processingCellInfo.isOnline
        if (cell.isOnline) {
            cell.backgroundColor = Constants.ONLINE_CONTACT_BACKGROUND_DEFAULT_COLOR
        } else {
            cell.backgroundColor = Constants.OFFLINE_CONTACT_BACKGROUND_DEFAULT_COLOR
        }
        cell.date = processingCellInfo.date
        cell.hasUnreadMessages = processingCellInfo.hasUnreadMessages
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    
}
