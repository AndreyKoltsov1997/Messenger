//
//  RecivedMessagesCell.swift
//  Chat
//
//  Created by Andrey Koltsov on 07/10/2018.
//  Copyright © 2018 Peter the Great St.Petersburg Polytechnic University. All rights reserved.
//

import UIKit

class RecivedMessagesCell: UITableViewCell {

    @IBOutlet weak var recivedMessageText: UITextView!
    @IBOutlet weak var backgroundImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        recivedMessageText.textContainer.heightTracksTextView = true
        recivedMessageText.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func setBackground(forState isRecived: Bool) {
        let imageName = "recived-message-background"
        
        guard let image = UIImage(named: imageName) else { return }
        backgroundImage.image = image
            .resizableImage(withCapInsets:
                UIEdgeInsetsMake(17, 21, 17, 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }
}
