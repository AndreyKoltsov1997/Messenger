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
    
    // MARK: - Properties
    private let identifier = String(describing: ConversationCell.self)
    public var recivedMessages = [Message]()
    private var sentMessages = [Message]()
    public var userName: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       self.title = userName
        
        chatTableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        chatTableView.register(UINib(nibName: String(describing: RecivedMessagesCell.self), bundle: nil), forCellReuseIdentifier: "reivecMessageCell")
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 60
        chatTableView.separatorColor = UIColor.clear
        let currentUser = Contact()
        for i in 0 ..< recivedMessages.count {
            let message = Message(withText: "Answer \(i)", from: currentUser, recivedIn: Date())
            sentMessages.append(message)
        }
        
    }
}

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // NOTE: Do nothing
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let amountOfMessagesInChat = 5;
        return amountOfMessagesInChat
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var displayingCell: UITableViewCell?
        if (indexPath.row % 2) == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ConversationCell else {
                // nil. We have to return a strong cell in this scope. E.g.:  any default cell.
                return UITableViewCell()
            }
            cell.setBackground(forState: true)
            // NOTE: I'm sorry, I don't have time to get the text into [Messages] array until deadline :(
            cell.messageTextView.text = "Answer for num \(indexPath.row) with approx 300 symbols: Turkish police said in a statement Saturday that 15 Saudis, including several officials, arrived in Istanbul on two planes and visited the consulate while Khashoggi was inside, the official Anadolu agency reported. A Saudi official said Khashoggi left the consulate shortly after he visited. The Saudis did not, however, release any surveillance footage or other evidence. ce. The crackdowns have targeted clerics, journalists, academics and activists, some of whom were detained outside Saudi Arabia."
            displayingCell = cell
        } else {
            // NOTE: I'm sorry, I don't have time to get the text into [Messages] array until deadline :(
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String("reivecMessageCell"), for: indexPath) as? RecivedMessagesCell else {
                // nil. We have to return a strong cell in this scope. E.g.:  any default cell.
                return UITableViewCell()
            }
            cell.recivedMessageText.text = "Msg for num \(indexPath.row) with approx 30 symbols: hashoggi, known in part for his interviews with terror mastermind Osama bin Laden, was a Saudi royal court insider before he left Saudi Arabia in 2017 for Washington. He began to contribute opinion pieces to The Washington Post."
            cell.setBackground(forState: false)
            displayingCell = cell
        }
        
        
        return displayingCell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let defaultNumberOfSections = 1
        return defaultNumberOfSections
    }
    
}
