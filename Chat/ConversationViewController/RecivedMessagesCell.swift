//
//  RecivedMessagesCell.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class RecivedMessagesCell: UITableViewCell {

    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var backgroundImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageText.textContainer.heightTracksTextView = true
        messageText.isScrollEnabled = false
        
        setBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        return
        // Configure the view for the selected state
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
