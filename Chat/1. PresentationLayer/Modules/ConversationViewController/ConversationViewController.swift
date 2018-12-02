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
    @IBOutlet weak var sendMessageBtn: UIButton!
    
    @IBAction func onSendMessageBtnPressed(_ sender: UIButton) {
        self.sendMessage(from: messageInputTextField)
    }
    
    // MARK: - Properties
    public var contact: Contact!
    public var userName: String = ""
    public var isInputEnabled: Bool = false
    weak var delegate: ConversationListViewControllerDelegate?
    private let sentMessageIdentifier = String(describing: SentMessageCell.self)
    private let recivingMessageIdentifier = String(describing: RecivedMessagesCell.self)

    private let AVALIABLE_USER_INPUT_PLACEHOLDER = "Message..."
    private let SEND_MESSAGE_TITLE = "Send"
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureChatTableView()
        navigationItem.title = contact.name
    }
    
    override func awakeFromNib() {
        self.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messageInputTextField.placeholder = self.AVALIABLE_USER_INPUT_PLACEHOLDER
        
        self.configureSendMessageButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateDialogues(for: self.contact)
    }
    
    private func configureSendMessageButton() {
        self.sendMessageBtn.setTitle(self.SEND_MESSAGE_TITLE, for: .normal)
        self.sendMessageBtn.setTitleColor(UIColor.white, for: .normal)
        
        self.sendMessageBtn.backgroundColor = UIColor.blue
        self.sendMessageBtn.layer.cornerRadius = 15
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
        processOnlineStateChaning(toOnlineStatus: false)
        
    }
    
    private func processOnlineStateChaning(toOnlineStatus isOnline: Bool) {
        self.messageInputTextField.isEnabled = isOnline
        isInputEnabled = isOnline
        let colorTransitionAnimation: () -> Void = {
            self.sendMessageBtn.backgroundColor = isOnline ? UIColor.blue : UIColor.red
        }
        UIView.transition(with: self.sendMessageBtn, duration: 0.5, options: .transitionCrossDissolve, animations: colorTransitionAnimation)
        
        let stateChangingAnimDuration = 0.5
        let frameGrowthPercentage = CGFloat(1.15)
        UIView.animate(withDuration: stateChangingAnimDuration, delay: 0, options: [], animations: {
            self.sendMessageBtn.transform = CGAffineTransform(scaleX: frameGrowthPercentage, y: frameGrowthPercentage)
        }, completion: { _ in
            UIView.animate(withDuration: stateChangingAnimDuration, delay: stateChangingAnimDuration, options: [], animations: {
                self.sendMessageBtn.transform = CGAffineTransform.identity
            }, completion: nil)
            
        })
    }
    
    public func unblockUserInput() {
        self.messageInputTextField.placeholder =  self.AVALIABLE_USER_INPUT_PLACEHOLDER
        processOnlineStateChaning(toOnlineStatus: true)
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
    
    private func sendMessage(from textField: UITextField) {
        textField.resignFirstResponder()
        guard let text = textField.text else {
            return
            
        }
        let newMessage = Message(identifier: generateMessageID(), text: text, isRecived: false, date: Date())
        self.contact.dialoque.append(newMessage)
        delegate?.sendMessage(newMessage, to: contact.peer)
        let clearedText = ""
        textField.text = clearedText
        chatTableView.reloadData()
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
    
}


// MARK: - ConversationViewControllerDelegate
extension ConversationViewController: ConversationViewControllerDelegate {
    func loadDialoque(withContact contact: Contact) {
        // TODO: ENcapsulate logic into a separate model
        self.contact = contact
    }
    
    
}
