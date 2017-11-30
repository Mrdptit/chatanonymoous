//
//  AppManager.swift
//  KOFA
//
//  Created by may1 on 11/15/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    var user:User!
    var logged:Bool!
    var currentConversationID : Int = 0
     var canSendImage:Bool!
    var user_Sevice : UserSevice!
    static let shared   :   AppManager = {
        let app = AppManager()
        // USER
        let userNil = User()
        let defaults = UserDefaults.standard
        app.logged = false
        app.currentConversationID = -999
        app.canSendImage = true
        app.user_Sevice = UserSevice()
        if(defaults.value(forKey: "currentUser") != nil){
            var data = Data()
            data = defaults.value(forKey: "currentUser") as! Data
            let dict = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
            var user = User()
            if dict is User{
                user = dict as! User
            }else{
                user = User(dict: dict as! [String : AnyObject])
            }
            print("DICT: \(String(describing: dict))");
            app.user = user
            app.logged = true
        }
        return app
    }()
    
    func countries() -> NSMutableArray{
        let list = NSMutableArray()
        let path = Bundle.main.path(forResource: "countries", ofType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return (jsonResult as! NSArray).mutableCopy() as! NSMutableArray
        } catch {
            return list
        }
    }
}
