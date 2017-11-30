//
//  OutMessTypeText.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class OutMessTypeText: UITableViewCell {
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var statusMessage: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.cornerRadius = 15.0
        statusMessage.layer.cornerRadius = statusMessage.layer.frame.size.height/2
        statusMessage.layer.masksToBounds = true
        // Initialization code
    }
    func getdataFrom(data : MessageView, showStatus : Bool){
        if showStatus{
          lblStatus.text      =  Utils.checkStatus(type: data.status)
        }else{
            lblStatus.text      =  nil
        }
        lblContent.text     =   data.content
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
