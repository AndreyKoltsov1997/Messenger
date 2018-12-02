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
    public var contact: Contact!
    public var userName: String = ""
    public var isInputBlocked: Bool = false
    weak var delegate: ConversationListViewControllerDelegate?
    private let sentMessageIdentifier = String(describing: SentMessageCell.self)
    private let recivingMessageIdentifier = String(describing: RecivedMessagesCell.self)

    private let AVALIABLE_USER_INPUT_PLACEHOLDER = "Message..."

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureChatTableView()
        navigationItem.title = contact.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messageInputTextField.placeholder = self.AVALIABLE_USER_INPUT_PLACEHOLDER
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
        isInputBlocked = true
    }
    
    public func unblockUserInput() {
        self.messageInputTextField.isEnabled = true
        self.messageInputTextField.placeholder =  self.AVALIABLE_USER_INPUT_PLACEHOLDER

        contact.isOnline = true
        isInputBlocked = false
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
        return self.contact.dialoque.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var displayingCell = UITableViewCell()
       let dialoque = contact.dialoque
        
        let isIndexValid = dialoque.indices.contains(indexPath.row)
        if (!isIndexValid) {
            return displayingCell
        }
        let message = dialoque[indexPath.row]
        
        if message.isRecived {
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
    
    func generateMessageID() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: Impliment message sending here
        textField.resignFirstResponder()
        guard let text = textField.text else {
            return true
        }
        let newMessage = Message(identifier: generateMessageID(), text: text, isRecived: false, date: Date())
        self.contact.dialoque.append(newMessage)
        delegate?.sendMessage(newMessage, to: contact.peer)
        let clearedText = ""
        textField.text = clearedText
        chatTableView.reloadData()
        return true
    }
}


// MARK: - ConversationViewControllerDelegate
extension ConversationViewController: ConversationViewControllerDelegate {
    func loadDialoque(withContact contact: Contact) {
        // TODO: ENcapsulate logic into a separate model
        self.contact = contact
    }
    
    
}
