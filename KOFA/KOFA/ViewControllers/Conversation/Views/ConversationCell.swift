//
//  ConversationCell.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Material

let arr_avatar = ["avatar-1","avatar-2","avatar-3","avatar-4","avatar-5","avatar-6","avatar-7","avatar-8","avatar-9","avatar-10","avatar-11","avatar-12"]
class ConversationCell: UITableViewCell {

    @IBOutlet weak var lblNewMess: UILabel!
    @IBOutlet weak var lblLastmess: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNewMess.layer.cornerRadius   =  6.0
        // Initialization code
    }
    func getdataToCell(data : Conversation){
        let randomIndex     =   Int(arc4random_uniform(UInt32(arr_avatar.count)))
        imgAvatar.image     =   UIImage.init(named: arr_avatar[randomIndex])
        lblName.text        =   data.name
        
        // alternative: not case sensitive
        if data.last_message?.lowercased().range(of:"https://i.imgur.com") != nil {
            lblLastmess.text    = "Uploaded a image"
        } else {
            lblLastmess.text    = data.last_message
        }
        
        lblTime.text        =   Utils.timeAgoFromNow(time: data.last_action_time!)
        if(data.is_read == 0){
            lblName.font = RobotoFont.bold(with: 15)
            lblLastmess.font = RobotoFont.bold(with: 14)
            lblTime.font = RobotoFont.bold(with: 13)
            lblNewMess.isHidden = false
        } else {
            lblName.font = RobotoFont.regular(with: 15)
            lblLastmess.font = RobotoFont.regular(with: 14)
            lblTime.font = RobotoFont.regular(with: 13)
            lblNewMess.isHidden = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
