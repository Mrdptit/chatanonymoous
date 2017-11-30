//
//  Conversation.swift
//  KOFA
//
//  Created by may1 on 11/15/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class Conversation: NSObject {
    var idConversation: Int? = Int()
    var isNew: Int? = Int()
    var name: String? = String()
    var created_at: Double? = Double()
    var last_message: String? = String()
    var last_action_time: Double? = Double()
    var last_id_update: Int? = Int()
    var background: String? = String()
    var created_by: Int? = Int()
    var members: NSArray? = NSArray()
    var is_read: Int? = Int()
    
    init(dict: [String: AnyObject]){
        idConversation = (dict[C_Id] as? Int) ?? 0
        isNew = (dict[C_isNew] as? Int) ?? 0
        name = (dict[C_Name] as? String) ?? ""
        created_at = (dict[
            C_CreatedAt] as? Double) ?? 0
        last_message = (dict[C_LastMessage] as? String) ?? ""
        last_id_update = (dict[C_LastIDUpdate] as? Int) ?? 0
        last_action_time = (dict[C_LastActionTime] as? Double) ?? 0
        background = (dict[C_Background] as? String) ?? ""
        created_by = (dict[C_CreatedBy] as? Int) ?? 0
        members = (dict[C_Members] as? NSArray) ?? NSArray()
        is_read = (dict[C_isRead] as? Int) ?? 1
    }
    
    override init() {
        super.init()
    }
}
