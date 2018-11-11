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
    var contact: ContactCD!
    weak var delegate: ConversationListViewControllerDelegate?
    private let sentMessageIdentifier = String(describing: SentMessageCell.self)
    private let recivingMessageIdentifier = String(describing: RecivedMessagesCell.self)
    var destinationPeer: Peer!

    public var userName: String = ""
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureChatTableView()
        navigationItem.title = contact.name
        self.chatTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messageInputTextField.placeholder = "Message..."
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateDialogues(for: self.contact)
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
        // TODO: Replace with delegate
        self.messageInputTextField.isEnabled = true
    }
    
    private func showAlert(message:String) {
        let alert  = UIAlertController(title: "Netowrk Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func updateView() {
        self.chatTableView.reloadData()
        self.messageInputTextField.isEnabled = contact.isOnline
    }
    
    public func blockUserInput() {
        contact.isOnline = false
        let username = self.contact?.name ?? "User"
        self.messageInputTextField.placeholder =  username + " is not avaliable."
        showAlert(message: username + " is no longer avaliable.")
        self.messageInputTextField.isEnabled = false
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
        guard let conversationID = contact.conversation.id else {
            return 0
        }
        guard let conversation = StorageCoreData.getConversation(withID: conversationID) else {
            return 0
        }
        guard let messages = conversation.messages else {
            return 0
        }
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var displayingCell = UITableViewCell()
        guard let dialoque = StorageCoreData.getConversation(withID: contact.conversation.id)?.messages else {
            return displayingCell
        }
        let isIndexValid = (indexPath.row <= dialoque.count - 1)
        if !isIndexValid {
            return displayingCell
        }
        let message = dialoque[indexPath.row]
        
        if message.isReceived {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: recivingMessageIdentifier, for: indexPath) as? RecivedMessagesCell else {
                return UITableViewCell()
            }
            cell.messageText = message.text
            displayingCell = cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sentMessageIdentifier, for: indexPath) as? SentMessageCell else {
                return UITableViewCell()
            }
            cell.messageText = message.text
            displayingCell = cell
        }
        return displayingCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let defaultNumberOfSections = 1
        return defaultNumberOfSections
    }
    
    
    func generateMessageID() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
}

// MARK: - UITextFieldDelegate
extension ConversationViewController: UITextFieldDelegate {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (!self.contact.isOnline) {
            let userName =  self.contact?.name ?? "User"
            showAlert(message: userName + " is offline and not avaliable for conversation.")
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: Impliment message sending here
        textField.resignFirstResponder()
        guard let text = textField.text else {
            return true
        }
        //let newMessage = Message(identifier: generateMessageID(), text: text, isRecived: false, date: Date())
        let newMessage = MessageCD(context: StorageCoreData.context)
        newMessage.conversation = StorageCoreData.getConversation(withID: self.contact.conversation.id)
        newMessage.date = Date() as NSDate
        newMessage.isReceived = false
        newMessage.text = text
        self.contact.conversation?.addToMessages(newMessage)
        
        delegate?.sendMessage(newMessage, to: self.destinationPeer)
        let clearedText = ""
        textField.text = clearedText
        chatTableView.reloadData()
        return true
    }
}


// MARK: - ConversationViewControllerDelegate
extension ConversationViewController: ConversationViewControllerDelegate {
    func loadDialoque(withContact contact: ContactCD) {
        // TODO: ENcapsulate logic into a separate model
        self.contact = contact
    }
    
    
}
