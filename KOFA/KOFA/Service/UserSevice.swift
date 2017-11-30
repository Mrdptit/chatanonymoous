//
//  UserSevice.swift
//  KOFA
//
//  Created by may1 on 11/15/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class UserSevice: BaseService {
    
    func authenticateWith(id: String, access_token: String, completion: @escaping (_ result: Bool)->()){
        let params = [K_Id:id, K_AccessToken: access_token]
        self.post(type: .API_AUTH, params: params as [String : AnyObject]) { (success, data) in
            var responseData = data!
            if((responseData["status"] as! Int) == 200){
                completion (true)
            } else {
                completion (false)
            }
        }
    }
    func signupWith(params :[String:AnyObject], completion: @escaping (_ result: Bool,_ reponse :AnyObject?)->()){
        self.post(type: API_SERVICE.API_SIGNUP, params: params) { (success, data) in
            completion (success, data as AnyObject)
        }
    }
    func signinWith(params : [String : AnyObject], completion: @escaping (_ result: Bool,_ reponse :AnyObject?)->()){
        self.post(type: .API_SIGNIN, params: params) { (success, data) in
            completion(success, data as AnyObject)
        }
    }
    func updateWith(params:[String : AnyObject], completion: @escaping (_ result: Bool,_ reponse :AnyObject?)->()){
        self.post(type: .API_UPDATE, params: params) { (success, data) in
            completion(success, data as AnyObject)
        }
    }
    
    func conversations(params:[String : AnyObject], completion: @escaping (_ result: Bool,_ reponse :AnyObject?)->()){
        self.get(type: .API_GET_CONVERSATIONS, params: params) { (success, data) in
            completion(success, data as AnyObject)
        }
    }
    
    func messages(params:[String : AnyObject], completion: @escaping (_ result: Bool,_ reponse :AnyObject?)->()){
        self.get(type: .API_GET_MESSAGES, params: params) { (success, data) in
            completion(success, data as AnyObject)
        }
    }
    func online(params:[String : AnyObject], completion: @escaping (_ result: Bool,_ reponse :AnyObject?)->()){
        self.get(type: .API_LIST_ONLINE, params: params) { (success, data) in
            completion(success, data as AnyObject)
        }
    }
    func getFriendChat(params:[String : AnyObject], completion: @escaping (_ result: Bool,_ reponse :AnyObject?)->()){
        self.get(type: .API_GET_FRIEND, params: params) { (success, data) in
            completion(success, data as AnyObject)
        }
    }
    func getInfo(params:[String : AnyObject], completion: @escaping (_ result: Bool,_ reponse :AnyObject?)->()){
        self.get(type: .API_GET_USER, params: params) { (success, data) in
            completion(success, data as AnyObject)
        }
    }
}
