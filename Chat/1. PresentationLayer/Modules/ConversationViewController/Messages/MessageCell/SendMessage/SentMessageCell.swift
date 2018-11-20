//
//  ConversationCell.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class SentMessageCell: UITableViewCell, MessageCellConfiguration {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageBackgroundImage: UIImageView!
    internal var messageText: String? {
        didSet {
            messageTextView.text = messageText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.layoutIfNeeded()
        super.updateConstraints()
        messageTextView.textContainer.heightTracksTextView = true
        messageTextView.isScrollEnabled = false
        setBackground()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // NOTE: Do nothing
    }
    
    public func setBackground() {
        let imageName = Constants.SENT_MESSAGE_CELL_BACKGROUND_RESOUCE_NAME
        guard let image = UIImage(named: imageName) else { return }
        messageBackgroundImage.image = image
            .resizableImage(withCapInsets:
                UIEdgeInsetsMake(17, 21, 17, 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }    
}
