//
//  IncomMessImage.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import AlamofireImage
class IncomMessImage: UITableViewCell {
    @IBOutlet weak var imgContent: UIImageView!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var activiti: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.layer.frame.size.height/2
        avatar.layer.masksToBounds = true
//        avatar.layer.borderColor = AppBaseColor.cgColor
//        avatar.layer.borderWidth = 2.0
        // Initialization code
    }
    func getdataFrom(data : MessageView){
        imgContent.af_setImage(withURL: URL.init(string: data.content!)!)
        self.activiti.stopAnimating()
        self.activiti.hidesWhenStopped = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
