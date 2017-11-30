//
//  IncomMessTypeText.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class IncomMessTypeText: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var lblContentText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.cornerRadius = 15.0
        viewContent.clipsToBounds = true
        avatar.layer.cornerRadius = avatar.layer.frame.size.height/2
        avatar.layer.masksToBounds = true
//        avatar.layer.borderColor = AppBaseColor.cgColor
//        avatar.layer.borderWidth = 2.0
        // Initialization code
    }
    func getdataFrom(data : MessageView){
        lblContentText.text =   data.content
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
