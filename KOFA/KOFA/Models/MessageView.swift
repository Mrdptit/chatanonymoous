//
//  MessageView.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class MessageView: NSObject {
    var idMessage : Int?            =   Int()
    var idConversation: Int?        =   Int()
    var senderID : Int?             =   Int()
    var type     : Int!             =   Int()
    var content  : String?          =   String()
    var timeAt   : Double?          =   Double()
    var typing   : Int!             =   0
    var status   : Int!  =   0
    //var status_friend   : Int!  =   0
    var data     : Data?            =   Data()
    var tempID  : Int?              = Int()
    override init() {
        super .init()
        
    }
    init(dict : [String : AnyObject]){
        idMessage = dict[M_IDMess] as? Int
        idConversation = dict[M_ConversationsID] as? Int
        senderID = dict[M_SenderID] as? Int
        type     = dict[M_Type]     as! Int
        content  = dict[M_Content]  as? String
        timeAt   = dict[M_TimeAT]   as? Double
        status   = dict[M_Status]   as? Int ?? 0
        //status_friend   = dict[M_StatusFriend]   as? Int ?? 0
        data     = dict[M_Data]     as? Data
        tempID    = dict[M_TempID]  as? Int ?? 0
    }
    private func sentMessImageWith(data : MessageView, user : User){
//        let date = Date()
//        let mess = [
//            M_SenderID          :   1,
//            M_Content           :   "",
//            M_TimeAT            :   date,
//            M_Status            :   0,
//            M_Type              :   2,
//            M_IDMess            :   0,
//            M_Data              :   data
//            ] as [String : Any]
    }
    private func sentMessText(data : MessageView, user : User){
//        let date = Date()
//        let mess = [
//            M_SenderID          :   1,
//            M_Content           :   content,
//            M_TimeAT            :   date,
//            M_Status            :   0,
//            M_Type              :   0,
//            M_IDMess            :   0
//            ] as [String : Any]
    }
}

