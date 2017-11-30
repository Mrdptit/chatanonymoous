//
//  OutmessTypeImage.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import AlamofireImage

class OutmessTypeImage: UITableViewCell {
    
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var imgcontent: UIImageView!
    @IBOutlet weak var activiti: UIActivityIndicatorView!
    
    @IBOutlet weak var statusMessage: UIImageView!
    var currentConversation: Conversation!
    var index : Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        imgcontent.layer.cornerRadius = 12.0
        imgcontent.layer.masksToBounds = true
        statusMessage.layer.cornerRadius = statusMessage.layer.frame.size.height/2
        statusMessage.layer.masksToBounds = true
        // Initialization code
    }
    func getdataFrom(data : MessageView, showStatus : Bool){
        //activiti.startAnimating()
        var image:UIImage!
        if(data.data != nil){
            image = UIImage.init(data: data.data!)
            image = Utils.resizeImage(image: image!, targetSize: CGSize(width: 200, height: 150))
            imgcontent.image     = image
        } else {
            imgcontent.af_setImage(withURL: URL(string: data.content ?? "hehe")!)
        }
        
        if showStatus || ![0,1,2].contains(data.status){
            lblstatus.text      =  Utils.checkStatus(type: data.status)
        }else{
            lblstatus.text      =  nil
        }
        
        if(data.data != nil && data.type == 2 && data.status == -1){
            //            image = UIImage.init(data: data.data!)
            //            image = Utils.resizeImage(image: image!, targetSize: CGSize(width: 200, height: 150))
            //            imgcontent.image     = image
            //            if ![0,1,2].contains(data.status) {
            //                MLIMGURUploader.uploadPhoto(UIImagePNGRepresentation(image!), title: "test", description: "content", imgurClientID: IMGUR_CLIENT_ID, progress: { (percent) in
            //
            //                    DispatchQueue.main.async {
            //                        // self.processBar.value = CGFloat(percent);
            //                    }
            //
            //                }, completionBlock: { (url) in
            //                    data.status = 1
            //                    self.activiti.stopAnimating()
            //                    self.activiti.hidesWhenStopped = true
            //                    if (url) != nil {
            //                        data.content = url
            //                        print(data.content as Any)
            //                        self.setNeedsDisplay()
            //                        // SEND MESS
            //                        let members = NSMutableArray()
            //                        for i in 0..<self.currentConversation.members!.count{
            //                            var list = self.currentConversation.members![i] as! [String: AnyObject]
            //                            let m = [K_Id: list[K_Id],
            //                                     K_NickName: list[K_NickName]]
            //                            members.add(m)
            //                        }
            //                        image = nil
            //                        data.data = nil
            //                        let message = [M_SenderID: AppManager.shared.user.idUser!,
            //                                       M_Content: data.content!,
            //                                       M_Type: 2,
            //                                       M_ConversationsID: self.currentConversation.idConversation!,
            //                                       C_Members: members] as [String : Any]
            //                        SocketConnect.shared.sendMessageToServer(message: message as [String : AnyObject]);
            //                        // END SEND
            //                    }
            //                }, failureBlock: { (rsponse, err, value) in
            //                    self.activiti.stopAnimating()
            //                    self.activiti.hidesWhenStopped = true
            //                })
            //            }
        } else {
            imgcontent.af_setImage(withURL: URL(string: data.content!)!)
            self.activiti.stopAnimating()
            self.activiti.hidesWhenStopped = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
