//
//  RecivedMessagesCell.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class RecivedMessagesCell: UITableViewCell, MessageCellConfiguration {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var backgroundImage: UIImageView!
    internal var messageText: String? {
        didSet {
            messageTextView.text = messageText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageTextView.textContainer.heightTracksTextView = true
        messageTextView.isScrollEnabled = false
        setBackground()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // NOTE: Do nothing
        return
    }
    
    public func setBackground() {
        let imageName = Constants.RECIVED_MESSAGE_CELL_BACKGROUND_RESOUCE_NAME
        
        guard let image = UIImage(named: imageName) else { return }
        backgroundImage.image = image
            .resizableImage(withCapInsets:
                UIEdgeInsetsMake(17, 21, 17, 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }
}
