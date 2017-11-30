//
//  BaseService.swift
//  KOFA
//
//  Created by may1 on 11/15/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


enum API_SERVICE {
    case API_SIGNUP
    case API_SIGNIN
    case API_UPDATE
    case API_AUTH
    case API_GET_CONVERSATIONS
    case API_GET_MESSAGES
    case API_LIST_ONLINE
    case API_GET_USER
    case API_GET_FRIEND
}
let base : String = "http://35.194.96.184"
let baseUrl : String = "\(base):8080/"
let SERVER_URL: String = "http://35.194.96.184:8080"
class BaseService: NSObject {
    static let shared = {
      return BaseService()
    }
    func getlinkUrlWith(type : API_SERVICE, params : [String : AnyObject]) -> String{
        var result = String()
        switch type {
        case .API_AUTH:
            result = "\(baseUrl)users/auth"
            break
        case .API_SIGNUP:
            result = "\(baseUrl)users/signup"
            break
        case .API_SIGNIN:
            result = "\(baseUrl)users/signin"
            break
        case .API_UPDATE:
            result = "\(baseUrl)users/update"
            break
        case .API_GET_CONVERSATIONS:
            result = "\(baseUrl)users/\(params[K_Id]!)/type=conversations?page=\(params[K_Page]!)&per_page=\(params[K_PerPage]!)&access_token=\(params[K_AccessToken]!)"
            break
        case .API_LIST_ONLINE:
            result = "\(baseUrl)users/\(params[K_Id]!)/type=online?page=\(params[K_Page]!)&per_page=\(params[K_PerPage]!)&access_token=\(params[K_AccessToken]!)"
            break
        case .API_GET_MESSAGES:
            result = "\(baseUrl)conversations/\(params[M_ConversationsID]!)/type=messages?page=\(params[K_Page]!)&per_page=\(params[K_PerPage]!)&access_token=\(params[K_AccessToken]!)&id=\(params[K_Id]!)"
            break
        case .API_GET_FRIEND:
            result = "\(baseUrl)conversations/\(params[M_ConversationsID]!)/type=friend?access_token=\(params[K_AccessToken]!)&id=\(params[K_Id]!)"
            break
        case .API_GET_USER:
            result = "\(baseUrl)users/\(params[K_Id]!)/type=info?access_token=\(params[K_AccessToken]!)&friend_id=\(params[K_FriendId]!)"
            break
        default:
            result =  ""
            break
        }
        return result
    }
    func get(type : API_SERVICE , params : [String:AnyObject],completion: @escaping (_ result: Bool,_ reponse :Any?)->()){
        let urlRequest = getlinkUrlWith(type: type,params: params)
        print("API URL: \(urlRequest)")
        let headers: [String: String] = [:]
        Alamofire.request(urlRequest, method: .get, parameters: nil, encoding:URLEncoding.default, headers: headers).responseJSON { (responseData) in
            if((responseData.result.value != nil)){
                completion(true,responseData.result.value as? [String : AnyObject])
            }else{
                completion(false,nil)
            }
        }
    }
    func post(type:API_SERVICE, params: [String : AnyObject],completion: @escaping(_ result: Bool,_ reponse : [String:AnyObject]?)-> ()) {
        let urlRequest = getlinkUrlWith(type: type,params: params)
        let headers: [String: String] = [:]
        Alamofire.request(urlRequest, method: .post, parameters: params, encoding:URLEncoding.default, headers: headers).responseJSON { (responseData) in
            print(responseData)
            if((responseData.result.value != nil)){
//                if (responseData) {
                completion(true,responseData.result.value as? [String : AnyObject])
//                }else{
//                    completion(false,nil)
//                }
            }else{
                completion(false,nil)
            }
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func parseData(JSONData: Data) ->[String:Any]?{
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options:.allowFragments) as! [String: Any]
            
            let items = readableJSON["items"] as! [[String: Any]]
            
            return items.first!
            
        }
        catch {
            print(error)
            return [:]
        }
    }

    
    
}
