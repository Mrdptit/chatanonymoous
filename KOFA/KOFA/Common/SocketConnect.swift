//
//  SocketConnect.swift
//  KOFA
//
//  Created by may10 on 11/21/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import SocketIO
import RNNotificationView
class SocketConnect: NSObject {
    let manager = SocketManager(socketURL: URL(string: SERVER_URL)!, config: [.reconnects(true), .log(false), .compress, .forceWebsockets(false), .forcePolling(true), .forceNew(true)])
    var socket: SocketIOClient!
    
    static let shared : SocketConnect = {
        let mng = SocketConnect()
        return mng
    }()
    
    func connectToServer(){
        self.socket.connect()
        self.socket.on(clientEvent: .connect) {data, ack in
            self.socket.emit("online", with: [[K_Id:AppManager.shared.user.idUser!, K_AccessToken:AppManager.shared.user.access_token!]])
            print("-------------- EMIT ONLINE \(String(describing: AppManager.shared.user.idUser))")
        }
        self.socket.on(clientEvent: .error) {data, ack in
            print(data)
        }
        self.socket.on(clientEvent: .disconnect) {data, ack in
            print(data)
        }
        self.socket.on("new_message") { (data, ack) in
            
        }
    }
    
    func addHandleMessage(completion: @escaping ([String: AnyObject])->()){
        self.socket.on("new_message") { (data, ack) in
            print(data)
            completion(data[0] as! [String: AnyObject])
            let temp : [String: AnyObject] = data[0] as! [String : AnyObject]
            if !(temp["conversations_id"] as? Int ?? 0 == AppManager.shared.currentConversationID) && !(temp["sender_id"] as? Int ?? 0 == AppManager.shared.user.idUser) {
                RNNotificationView.show(withImage: UIImage(named: "ic_new-message"),
                                        title: "New message",
                                        message: temp["content"] as? String,
                                        duration: 2,
                                        iconSize: CGSize(width: 24, height: 24),
                                        onTap: {
                                            
                }
                )
            }
        }
    }
    func addHandleSeen(completion: @escaping ([String: AnyObject])->()){
        self.socket.on("seen") { (data, ack) in
            completion(data[0] as! [String: AnyObject])
        }
    }
    func addHandleTyping(completion: @escaping ([String: AnyObject])->()){
        self.socket.on("typing") { (data, ack) in
            completion(data[0] as! [String: AnyObject])
        }
    }
    func addHandleOut(completion: @escaping ([String: AnyObject])->()){
        self.socket.on("out") { (data, ack) in
            completion(data[0] as! [String: AnyObject])
        }
    }
    func addHandleSearchings(completion: @escaping (Bool, [String: AnyObject])->()){
        self.socket.on("searchings") { (data, ack) in
            if(data[0] is NSNumber){
                completion(false, ["status":0 as AnyObject])
            } else {
                print(data[0])
                completion(true, data[0] as! [String: AnyObject])
            }
        }
    }
    
    
    func sendMessageToServer(message: [String: AnyObject]){
        self.socket.emit("new_message", with: [message])
    }
    
    
    
    func emit(on: String, any: [Any]){
        if self.socket.status == .connected {
            self.socket.emit(on, with: any)
        } else {
            self.socket.connect()
        }
    }
    
    
    
    override init() {
        super.init()
        self.socket = self.manager.defaultSocket
    }
}

