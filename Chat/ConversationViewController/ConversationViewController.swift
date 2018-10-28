//
//  ConversationViewController.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

struct DisplayingMessage {
    var message: Message
    let id: Int
    let isRecived: Bool
    
    init(message newMessage: Message, _ isRecived: Bool) {
        self.message = newMessage
        self.isRecived = isRecived
        self.id = DisplayingMessage.getUniqueIdentifier()
    }
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return DisplayingMessage.identifierFactory
    }
}
class ConversationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageInputTextField: UITextField!
    
    // MARK: - Properties
    var contact: Contact!
    private let sentMessageIdentifier = String(describing: SentMessageCell.self)
    private let recivingMessageIdentifier = String(describing: RecivedMessagesCell.self)
    
   // private var displayingMessages: [[Bool: Message]] = []
    private var messages: [DisplayingMessage] = []
    
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
        let msg = Message(identifier: generateMessageID(), text: "lol")
        self.messages.append(DisplayingMessage(message: msg, true))
//        displayingMessages.append(Message(withText: "Hey! I'm writing you a 30-symbol message.", from: nil))
//        displayingMessages.append(Message(withText: "O", from: self.contact))
//        displayingMessages.append(Message(withText: "That's nice to hear. By the way, I want to respond with a bigger message. Such as this one. Wooh, that's so nice to see how much letters we can put in a text like this one. Do you find it so attractive either? I think you do. Otherwise, you won't be chatting with a person like myself.", from: self.contact))
//        displayingMessages.append(Message(withText: "Well umm...talk to you later. Maybe in next life or so.", from: nil))
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var displayingCell: UITableViewCell?
        let message = messages[indexPath.row]
        
        if message.isRecived {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: recivingMessageIdentifier, for: indexPath) as? RecivedMessagesCell else {
                return UITableViewCell()
            }
            cell.messageText = message.message.text
            displayingCell = cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sentMessageIdentifier, for: indexPath) as? SentMessageCell else {
                return UITableViewCell()
            }
            cell.messageText = message.message.text
            displayingCell = cell
        }

        return displayingCell!
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: Impliment message sending here
        textField.resignFirstResponder()
        sentMessages.append(Message(identifier: generateMessageID(), text: textField.text!))
      //  displayingMessages.append(Message(withText: textField.text, from: nil))
        let clearedText = ""
        textField.text = clearedText
        chatTableView.reloadData()
        return true
    }
}
