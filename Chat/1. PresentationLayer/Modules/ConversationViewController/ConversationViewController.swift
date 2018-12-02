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
    
    private let CONTACT_LABEL_COLOR_OFFLINE = UIColor.black
    private let CONTACT_LABEL_COLOR_ONLINE = UIColor(red:0.20, green:0.80, blue:0.20, alpha:1.0)

    
    private let SEND_BUTTON_COLOR_ONLINE = UIColor(red:0.00, green:0.47, blue:1.00, alpha:1.0)
    private let SEND_BUTTON_COLOR_OFFLINE = UIColor.gray

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureChatTableView()
        configureNavBar()
        configureMessageInputTextField()
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
    
    private func configureMessageInputTextField() {
        self.messageInputTextField.addTarget(self, action: #selector(ConversationViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    private func configureSendMessageButton() {
        self.sendMessageBtn.setTitle(self.SEND_MESSAGE_TITLE, for: .normal)
        self.sendMessageBtn.setTitleColor(UIColor.white, for: .normal)
        self.sendMessageBtn.layer.cornerRadius = self.sendMessageBtn.frame.height * 0.4
        
        // NOTE: Changing "send" button color to gray based on homework's text (should't be highlighted when ...
        // .. texfield input is empty.
        let isButtonHightlightedByDefault = false
        self.changeSendMessageButtonAppearence(forOnlineState: isButtonHightlightedByDefault)
    }
    
    private func configureNavBar() {
        let titleFrame = CGRect(x: 10.0, y: 10.0, width: self.view.frame.width, height: self.view.frame.width * 0.10)
        let title = UILabel(frame: titleFrame)
        title.text = contact.name
        title.textAlignment = .center
        navigationItem.titleView = title
        self.changeContactNameLabelAppearence(forOnlineState: contact.isOnline)

    }
    
    private func configureChatTableView() {
        chatTableView.register(UINib(nibName: sentMessageIdentifier, bundle: nil), forCellReuseIdentifier: sentMessageIdentifier)
        chatTableView.register(UINib(nibName: recivingMessageIdentifier, bundle: nil), forCellReuseIdentifier: recivingMessageIdentifier)
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 60
        chatTableView.separatorColor = UIColor.clear
        chatTableView.dataSource = self
        chatTableView.allowsSelection = false
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
    
    private func getContactNameLabelInstance() -> UILabel? {
        guard let contactNameLabel = navigationItem.titleView as? UILabel else {
            print("Unable to get instance of navigation item label.")
            return nil
        }

        return contactNameLabel
    }
    
    private func processOnlineStateChaning(toOnlineStatus isOnline: Bool) {
        self.messageInputTextField.isEnabled = isOnline
        isInputEnabled = isOnline
        changeContactNameLabelAppearence(forOnlineState: isOnline)
        changeSendMessageButtonAppearence(forOnlineState: isOnline)
    }
    
    private func changeSendMessageButtonAppearence(forOnlineState isOnline: Bool) {
        let colorTransitionAnimation: () -> Void = {
            self.sendMessageBtn.backgroundColor = isOnline ? self.SEND_BUTTON_COLOR_ONLINE : self.SEND_BUTTON_COLOR_OFFLINE
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
    
    private func changeContactNameLabelAppearence(forOnlineState isOnline: Bool) {
        guard let contactNameLabel = self.getContactNameLabelInstance() else {
            return
        }
        let colorTransitionAnimation: () -> Void = {
            contactNameLabel.textColor = isOnline ? self.CONTACT_LABEL_COLOR_ONLINE : self.CONTACT_LABEL_COLOR_OFFLINE
        }
        let transitionDuration = 1.0
        let labelGrownInPercentage = CGFloat(1.10)
        
        UIView.transition(with: contactNameLabel, duration: 0.5, options: .transitionCrossDissolve, animations: colorTransitionAnimation)

        UIView.animate(withDuration: transitionDuration, delay: 0, options: [], animations: {
            contactNameLabel.transform = isOnline ? CGAffineTransform(scaleX: labelGrownInPercentage, y: labelGrownInPercentage) : CGAffineTransform.identity
        }, completion: nil)

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
        if text.isEmpty {
            return
        }
        let newMessage = Message(identifier: generateMessageID(), text: text, isRecived: false, date: Date())
        self.contact.dialoque.append(newMessage)
        delegate?.sendMessage(newMessage, to: contact.peer)
        let clearedText = ""
        textField.text = clearedText
        chatTableView.reloadData()
        
        // NOTE: Changing "send" button color to gray based on homework's text (should't be highlighted when ...
        // .. texfield input is empty.
        let isButtonHighlighted = false
        self.changeSendMessageButtonAppearence(forOnlineState: isButtonHighlighted)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let isBtnStateOnline = (self.sendMessageBtn.backgroundColor == self.SEND_BUTTON_COLOR_ONLINE)
        if (text.isEmpty && isBtnStateOnline) {
            self.changeSendMessageButtonAppearence(forOnlineState: false)
        } else if (!text.isEmpty && !isBtnStateOnline) {
            self.changeSendMessageButtonAppearence(forOnlineState: self.contact.isOnline)

        }
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
