//
//  OutmessTypeSticker.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class OutmessTypeSticker: UITableViewCell {
    @IBOutlet weak var imgContent: UIImageView!
    
    @IBOutlet weak var statusMessage: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        statusMessage.layer.cornerRadius = statusMessage.layer.frame.size.height/2
        statusMessage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
