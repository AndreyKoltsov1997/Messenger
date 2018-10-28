//
//  ConversationViewController.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageInputTextField: UITextField!
    
    // MARK: - Properties
    var contact: Contact!
    private let sentMessageIdentifier = String(describing: SentMessageCell.self)
    private let recivingMessageIdentifier = String(describing: RecivedMessagesCell.self)
    
    private var displayingMessages = [Message]()
    
    public var recivedMessages = [Message]()
    private var sentMessages = [Message]()
    public var userName: String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureChatTableView()
        createDisplayingMessages()
        navigationItem.title = contact.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messageInputTextField.placeholder = "Message..."
    }
    
    private func createDisplayingMessages() {
        displayingMessages.append(Message(withText: "Hey! I'm writing you a 30-symbol message.", from: nil))
        displayingMessages.append(Message(withText: "O", from: self.contact))
        displayingMessages.append(Message(withText: "That's nice to hear. By the way, I want to respond with a bigger message. Such as this one. Wooh, that's so nice to see how much letters we can put in a text like this one. Do you find it so attractive either? I think you do. Otherwise, you won't be chatting with a person like myself.", from: self.contact))
        displayingMessages.append(Message(withText: "Well umm...talk to you later. Maybe in next life or so.", from: nil))
    }
    
    private func configureChatTableView() {
        chatTableView.register(UINib(nibName: sentMessageIdentifier, bundle: nil), forCellReuseIdentifier: sentMessageIdentifier)
        chatTableView.register(UINib(nibName: recivingMessageIdentifier, bundle: nil), forCellReuseIdentifier: recivingMessageIdentifier)
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 60
        chatTableView.separatorColor = UIColor.clear
        chatTableView.dataSource = self
        self.title = userName
        self.messageInputTextField.delegate = self
    }
    
}

// MARK: - UITableViewDelegate
extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var displayingCell: UITableViewCell?
        let processingMessage = displayingMessages[indexPath.row];
        if processingMessage.sender != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: recivingMessageIdentifier, for: indexPath) as? RecivedMessagesCell else {
                return UITableViewCell()
            }
            cell.messageText = processingMessage.text
            displayingCell = cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sentMessageIdentifier, for: indexPath) as? SentMessageCell else {
                return UITableViewCell()
            }
            cell.messageText = processingMessage.text
            displayingCell = cell
        }
        
        return displayingCell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let defaultNumberOfSections = 1
        return defaultNumberOfSections
    }
    
}

// MARK: - UITextFieldDelegate
extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: send message here

        textField.resignFirstResponder()
        return true
    }
}
