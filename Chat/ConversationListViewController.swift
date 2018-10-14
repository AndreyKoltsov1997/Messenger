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
    // NOTE: PARAM @User - encapsulates default user info
    private let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NOTE: register the cell in the table
        
        // PARAM "bundle" is nill because we're using it within the app.
        // nibName and identifier are equals because of the file names.
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func resetCellData(_ cell: ConversationsListCell) {
        cell.usernameLabel.text = ""
        cell.messageTextLabel.text = ""
        cell.messageDateLabel.text = ""
    }
    private func fillUpCellData(_ cell: ConversationsListCell, withIndex index: IndexPath) {
        var requiredUsers = getUsersForSection(withNumber: index.section)
        
        // NOTE: if no users of the specified group has been found
        if (requiredUsers.count == 0) {
            return;
        }
        let number = index.row
        let currentContact = requiredUsers[number]
        if (currentContact.isOnline) {
            cell.backgroundColor = Constants.ONLINE_CONTACT_BACKGROUND_DEFAULT_COLOR
        } else {
            cell.backgroundColor = Constants.OFFLINE_CONTACT_BACKGROUND_DEFAULT_COLOR
        }
        cell.name = currentContact.name
        let lastRecivedMessage = user.getLastRecivedMessage(from: currentContact)
        cell.message = lastRecivedMessage.text
        let messageFontSize = cell.messageTextLabel.font.pointSize
        if lastRecivedMessage.isUnread {
            cell.messageTextLabel.font = UIFont.boldSystemFont(ofSize: messageFontSize)
        } else {
            cell.messageTextLabel.font = UIFont.systemFont(ofSize: messageFontSize)
        }
//        cell.date = lastRecivedMessage.date
    }
    
    private func getUsersForSection(withNumber number: Int) -> [Contact] {
        let sectionHeader = chatSections[number]
        var requiredUsers = [Contact]()
        switch sectionHeader {
        case Constants.ONLINE_USERS_SECTION_HEADER:
            requiredUsers = user.getRequiredContacts(isOnline: true)
        case Constants.OFFLINE_USERS_SECTION_HEADER:
            requiredUsers = user.getRequiredContacts(isOnline: false)
            break
        default:
            break
        }
        return requiredUsers
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
        conversationViewController.userName = cell.usernameLabel.text!
        var requiredUsers = getUsersForSection(withNumber: indexPath.section)
        
        // NOTE: if no users of the specified group has been found
        if (requiredUsers.count == 0) {
            return;
        }
        let number = indexPath.row
        let currentContact = requiredUsers[number]
        
        conversationViewController.recivedMessages = user.getRecivedMessages(from: currentContact)
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
        return getUsersForSection(withNumber: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // guard is used for type cast of the UITableViewCell to ConversationsListCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationsListCell else {
            // nil. We have to return a strong cell in this scope. E.g.:  any default cell.
            return UITableViewCell()
        }
        self.resetCellData(cell)
        // NOTE: configuring the cell
        self.fillUpCellData(cell, withIndex: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    
}
