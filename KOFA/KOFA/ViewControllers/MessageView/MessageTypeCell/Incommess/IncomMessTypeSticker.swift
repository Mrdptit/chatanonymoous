//
//  IncomMessTypeSticker.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class IncomMessTypeSticker: UITableViewCell {

    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.layer.frame.size.height/2
        avatar.layer.masksToBounds = true
//        avatar.layer.borderColor = AppBaseColor.cgColor
//        avatar.layer.borderWidth = 2.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
