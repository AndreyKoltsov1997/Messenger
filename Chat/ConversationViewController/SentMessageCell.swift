//
//  ConversationCell.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class SentMessageCell: UITableViewCell {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageBackgroundImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       messageTextView.text = ""
        super.layoutIfNeeded()
        super.updateConstraints()
        messageTextView.textContainer.heightTracksTextView = true
        messageTextView.isScrollEnabled = false
        setBackground()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state

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
