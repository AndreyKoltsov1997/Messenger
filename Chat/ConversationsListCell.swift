//
//  ConversationsListCell.swift
//  Chat
//
//  Created by Andrey Koltsov on 03/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class ConversationsListCell: UITableViewCell, ConversationCellConfiguration {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageDateLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    // MARK: - Properties
    var name: String? {
        willSet {
            usernameLabel.text = newValue
        }
    }
    
    var message: String? {
        willSet {
            if newValue == nil {
                messageTextLabel.text = "No messages yet"
            } else {
                messageTextLabel.text = newValue
            }
        }
    }
    
    
    var date: Date? {
        willSet {
            let dateFormatter = DateFormatter()
            if let newValue = newValue {
                dateFormatter.dateFormat = getDateFormat(for: newValue)
                dateFormatter.locale = Constants.DATE_FORMAT_DEFAULT_LOCALE
                messageDateLabel.text = dateFormatter.string(from: newValue)
            }
        }
    }
    
    var isOnline: Bool = false
    var hasUnreadMessages: Bool = false
    var assignedConversationId: String? 

    public func configureCell(_ name: String, _ message: String?, _ date: Date?, _ isOnline: Bool, _ hasUnreadMessages: Bool) {
        usernameLabel.text = name
        messageTextLabel.text = message
    }

    
    private func getDateFormat(for date: Date) -> String {
    // NOTE: Check MESSAGE_RECIVED_TODAY_DATE_FORMAT's note to get info about date displaying logic
        return isDateTheSame(date) ? Constants.MESSAGE_RECIVED_TODAY_DATE_FORMAT : Constants.MESSAGE_RECIVED_IN_THE_PAST_DATE_FORMAT
    }
    
    private func isDateTheSame(_ date: Date) -> Bool {
        let currentDate = Date()
        return Calendar.current.isDate(date, inSameDayAs: currentDate)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureProfilePicture()
    }
    
    private func configureProfilePicture() {
        // NOTE: Change picture's shape to circular
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        self.profileImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
