//
//  MessageViewVC.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import Material
import FCAlertView
import RNNotificationView
enum MessType{
    case MessTypeText
    case MessTypeSticker
    case MessTypeImage
}
// popMenu
let listcontent = ["View Profile","Exit"]
let listImg     = ["ic_profile","ic_exit"]

//identifil
let IncomTypeText           = "IncomMessTypeText"
let IncomTypeSticker        = "IncomMessTypeSticker"
let IncomTypeImage          = "IncomMessImage"
let OutgoingTypeText        = "OutMessTypeText"
let OutgoingTypeSticker     = "OutmessTypeSticker"
let OutgoingTypeImage       = "OutmessTypeImage"
class MessageViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewAccessibilityDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, listImageDelegate,FCAlertViewDelegate {
    fileprivate var menuButton: IconButton!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var viewSignout: UIView!
    @IBOutlet weak var bottomTableView: NSLayoutConstraint!
    
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var textSignout: UILabel!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var contransViewInput: NSLayoutConstraint!
    var MessViewData : NSMutableArray!
    @IBOutlet weak var bottomKeyBoard: NSLayoutConstraint!
    var viewList = ListImage()
    var user = User()
    @IBOutlet weak var txtzInput: UITextView!
    @IBOutlet weak var btnEmoji: UIButton!
    @IBOutlet weak var viewTextinput: UIView!
    @IBOutlet weak var btnSent: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblTyping: UILabel!
    @IBOutlet weak var tableViewMess: UITableView!
    var isHiddenKeyboard = Bool()
    var currentIndex = 0
    let picker = UIImagePickerController()
    
    var currentConversation: Conversation!
    
    var typingView: UIView!
    var messageTyping: UIView!
    var avatarTyping: UIImageView!
    let debouncer = Debouncer(interval: 0.5)
    var isLoad = Bool()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AppManager.shared.currentConversationID = currentConversation.idConversation!
        loadMessDataAt(index: 0)
        
    }
    private func loadMessDataAt(index : Int){
        let params = [M_ConversationsID: self.currentConversation.idConversation!,
                      K_Id: AppManager.shared.user.idUser!,
                      K_Page: index,
                      K_PerPage: 20,
                      K_AccessToken: AppManager.shared.user.access_token!] as [String: Any]
        
        UserSevice().messages(params: params as [String : AnyObject]) { (status, responseData) in
            var data = responseData as! [String:AnyObject]
            if((data["status"] as! Int) == 200){
                let array = data["message"] as! NSArray
                self.MessViewData.addObjects(from:  NSMutableArray(array: array) as! [Any])
                self.isLoad = true
                self.currentIndex += 1
                self.tableViewMess.reloadData()
            }else{
                self.isLoad = false
            }
        }
        if self.currentConversation.isNew == 0 {
            self.viewSignout.isHidden = false
        } else {
            self.viewSignout.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppManager.shared.currentConversationID = -999
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewMess.sectionHeaderHeight = 0
        picker.delegate = self
        self.txtzInput.delegate =   self
        MessViewData = NSMutableArray()
        tableViewMess.transform = CGAffineTransform(rotationAngle: -.pi);
        loadCellFormNid()
        keyboardCusstom()
        enableKeyboardHideOnTap()
        prepareMenuButton()
        prepareNavigationItem()
        // MARK: Socket Message
        SocketConnect.shared.emit(on: "seen", any: [[K_Id:AppManager.shared.user.idUser,
                                                     M_ConversationsID: self.currentConversation.idConversation]])
        SocketConnect.shared.addHandleSeen { (data) in
            // ------------ SOCKET SEEN ------------
            let cvs_id = data[M_ConversationsID] as? Int ?? 0
            let frid = data[K_Id] as? Int ?? 0
            if(cvs_id == self.currentConversation.idConversation && frid != AppManager.shared.user.idUser){
                var message = self.MessViewData.object(at: 0) as! [String:Any]
                message[M_Status] = 3
                self.MessViewData.replaceObject(at: 0, with: message)
                self.tableViewMess.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        
        SocketConnect.shared.addHandleTyping { (data) in
            let cvs_id = data[M_ConversationsID] as? Int ?? 0
            let frid = data[K_Id] as? Int ?? 0
            let typing = data[C_Typing] as? Int ?? 0
            if(typing == 1 && cvs_id == self.currentConversation.idConversation && frid != AppManager.shared.user.idUser){
                self.showTyping(show: true)
            } else {
                self.showTyping(show: false)
            }
        }
        
        SocketConnect.shared.addHandleMessage { (data) in
            //print("-------------SOCKET MESSAGE---------- \n \(data)")
            let mess = [
                M_SenderID          :   data[M_SenderID]!,
                M_Content           :   data[M_Content] as? String ?? "",
                M_TimeAT            :   data[M_TimeAT] as? Float ?? 0,
                M_Status            :   data[M_Status] as? Int ?? 0,
                M_Type              :   data[M_Type] as? Int ?? 0 as Any,
                M_IDMess            :   data[M_IDMess] as? Int ?? 0,
                M_TempID            :   data[M_TempID] as? Int ?? 0 as Any
                ] as [String : Any]
            if let topController = UIApplication.topViewController() {
                if(topController.isKind(of: MessageViewVC.self)){
                    SocketConnect.shared.emit(on: "seen", any: [[K_Id:AppManager.shared.user.idUser,
                                                                 M_ConversationsID: self.currentConversation.idConversation]])
                }
            }
            let message = MessageView(dict: mess as [String : AnyObject])
            if(data[M_ConversationsID] as? Int ?? 0 == self.currentConversation.idConversation){
                if(message.senderID != AppManager.shared.user.idUser){
                    self.MessViewData.insert(mess, at: 0)
                    self.tableViewMess.beginUpdates()
                    self.tableViewMess.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self.tableViewMess.endUpdates()
                } else {
                    self.MessViewData.replaceObject(at: 0, with: mess)
                    self.tableViewMess.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }else{
                
            }
        }
        
        SocketConnect.shared.addHandleOut { (data) in
            if(data[M_ConversationsID] as? Int ?? 0 == self.currentConversation.idConversation){
                self.viewSignout.isHidden = false
                self.textSignout.text = "STRANGER HAS EXIT"
                self.hideKeyboard()
            }
            print(data)
        }
        
    }
    
    
    func reloadCellData(data: [String:AnyObject]){
        let mess = MessageView(dict: data)
        for i in 0..<self.MessViewData.count{
            let message = self.MessViewData.object(at: i) as! [String:AnyObject]
            let index = message[M_TempID] as? Int ?? -999
            if(index == mess.tempID && mess.senderID == AppManager.shared.user.idUser){
                self.MessViewData.replaceObject(at: i, with: data)
                self.tableViewMess.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            }
        }
    }
    
    //    MARK: XỬ LÝ TIN NHẮN GỬI NẾU LỖI
    func tempIDforMessage() -> Int{
        let defaults = UserDefaults.standard
        var number:Int = defaults.integer(forKey: "AUTOID")
        number += 1
        defaults.set(number, forKey: "AUTOID")
        defaults.synchronize()
        return number
    }
    func addMessageError(dict: [String:AnyObject]){
        let defaults = UserDefaults.standard
        if(defaults.value(forKey: "errors") != nil){
            let data:Data = defaults.value(forKey: "errors") as! Data
            let messages = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSMutableArray
            messages.add(dict)
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: messages), forKey: "errors")
            defaults.synchronize()
        } else {
            let messages = NSMutableArray()
            messages.add(dict)
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: messages), forKey: "errors")
            defaults.synchronize()
        }
    }
    
    func getIndexPath(byTempID: Int) -> IndexPath{
        for i in 0..<self.MessViewData.count{
            let message = self.MessViewData.object(at: i) as! [String:AnyObject]
            let index = message[M_TempID] as? Int ?? 0
            if(index == byTempID){
                return IndexPath(row: i, section: 0)
            }
        }
        return IndexPath(row: -9999, section: 0)
    }
    
    func removeMessageNoError(withTempID: Int){
        let defaults = UserDefaults.standard
        if(defaults.value(forKey: "errors") != nil){
            let data:Data = defaults.value(forKey: "errors") as! Data
            let messages = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSMutableArray
            for i in 0..<messages.count{
                let mess = messages.object(at: i) as! [String:AnyObject]
                if(mess[M_IDMess] as? Int ?? -999 == withTempID){
                    messages.removeObject(at: i)
                    defaults.set(NSKeyedArchiver.archivedData(withRootObject: messages), forKey: "errors")
                    defaults.synchronize()
                }
            }
        }
    }
    
    
    func loadCellFormNid() {
        tableViewMess.register(UINib.init(nibName: "IncomMessTypeText", bundle: nil), forCellReuseIdentifier: IncomTypeText)
        tableViewMess.register(UINib.init(nibName: "IncomMessTypeSticker", bundle: nil), forCellReuseIdentifier: IncomTypeSticker)
        tableViewMess.register(UINib.init(nibName: "IncomMessImage", bundle: nil), forCellReuseIdentifier: IncomTypeImage)
        tableViewMess.register(UINib.init(nibName: "OutMessTypeText", bundle: nil), forCellReuseIdentifier: OutgoingTypeText)
        tableViewMess.register(UINib.init(nibName: "OutmessTypeSticker", bundle: nil), forCellReuseIdentifier: OutgoingTypeSticker)
        tableViewMess.register(UINib.init(nibName: "OutmessTypeImage", bundle: nil), forCellReuseIdentifier: OutgoingTypeImage)
        viewList = Bundle.loadView(fromNib: "ListImage", withType: ListImage.self)
        viewList.frame = CGRect(x: 0.0, y: Double(Device_Height) - Double(Defaul_KeyBoard) - 60, width: Double(self.view.frame.width*1.0), height: Double(Defaul_KeyBoard))
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSentmess(_ sender: UIButton) {
        if ((txtzInput.text?.count) != nil && txtzInput.text?.count ?? 0 > 0){
            let members = NSMutableArray()
            for i in 0..<self.currentConversation.members!.count{
                var list = self.currentConversation.members![i] as! [String: AnyObject]
                let m = [K_Id: list[K_Id],
                         K_NickName: list[K_NickName]]
                members.add(m)
            }
            let tempID = self.tempIDforMessage();
            let message = [M_SenderID: AppManager.shared.user.idUser!,
                           M_Content: txtzInput.text!,
                           M_Type: 0,
                           M_ConversationsID: self.currentConversation.idConversation!,
                           M_IDMess: tempID,
                           M_TempID: tempID,
                           C_Members: members] as [String : Any]
            self.addMessageError(dict: message as [String : AnyObject])
            self.MessViewData.insert(message, at: 0)
            self.tableViewMess.reloadData()
            
            SocketConnect.shared.sendMessageToServer(message: message as [String : AnyObject]);
            txtzInput.text = nil
        }
    }
    
    @IBAction func btnShowEmoji(_ sender: UIButton) {
    }
    @IBAction func btnActionMore(_ sender: UIButton) {
        if btnMore.tag == 0{
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.contransViewInput.constant = 68
                self.btnMore.transform = CGAffineTransform(rotationAngle: .pi/4);
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                self.btnMore.tag = 1
            })
        }else{
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.contransViewInput.constant = 8
                self.btnMore.transform = CGAffineTransform(rotationAngle: .pi/2);
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                self.btnMore.tag = 0
            })
        }
    }
    @IBAction func btnCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnPhoto(_ sender: Any){
        self.txtzInput.resignFirstResponder()
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations:
            {
                if(self.bottomKeyBoard.constant == 0){
                    self.bottomKeyBoard.constant = CGFloat(Defaul_KeyBoard)
                    self.view.layoutIfNeeded()
                }
                self.view.addSubview(self.viewList)
                self.view.bringSubview(toFront: self.viewList)
                self.viewList.clickMore = {
                    self.showPickerImage()
                    
                }
                self.viewList.delegate = self
                
        }, completion: nil)
        
    }
    func tapImage(at collectionview: UICollectionView, index: Int, withData image: Data) {
        if(AppManager.shared.canSendImage == true){
            AppManager.shared.canSendImage = false
            self.sentMessImageWith(data: image, user: self.user)
            self.tableViewMess.reloadData()
            let when = DispatchTime.now() + 30
            DispatchQueue.main.asyncAfter(deadline: when) {
                AppManager.shared.canSendImage = true
            }
        } else {
            // ALERT
            FCAlertView().showAlert(withTitle:"NOTIFICATION"
                , withSubtitle: "Try again after 30 seconds", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
        }
    }
}

// MARK: TYPING
extension MessageViewVC {
    func sendTyping(bool: Bool){
        if bool == true {
            let typing = [M_ConversationsID: self.currentConversation.idConversation!,
                          K_Id: AppManager.shared.user.idUser!,
                          C_Typing: 1] as [String:Any]
            SocketConnect.shared.emit(on: "typing", any: [typing])
        } else {
            let typing = [M_ConversationsID: self.currentConversation.idConversation!,
                          K_Id: AppManager.shared.user.idUser!,
                          C_Typing: 0] as [String:Any]
            SocketConnect.shared.emit(on: "typing", any: [typing])
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.debouncer.callback = {
            self.sendTyping(bool: true)
        }
        debouncer.call()
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.contransViewInput.constant = 8
            self.btnMore.transform = CGAffineTransform(rotationAngle: .pi/2);
        }, completion: { (true) in
            self.btnMore.tag = 0
        })
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.sendTyping(bool: false)
    }
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

// MARK: - PickerImage
extension MessageViewVC {
    
    func showPickerImage(){
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        /// chcek if you can return edited image that user choose it if user already edit it(crop it), return it as image
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let data = UIImagePNGRepresentation(editedImage)
            
            if(AppManager.shared.canSendImage == true){
                AppManager.shared.canSendImage = false
                self.sentMessImageWith(data: data!, user: self.user)
                let when = DispatchTime.now() + 30
                DispatchQueue.main.asyncAfter(deadline: when) {
                    AppManager.shared.canSendImage = true
                }
            } else {
                // ALERT
                FCAlertView().showAlert(withTitle:"NOTIFICATION"
                    , withSubtitle: "Try again after 30 seconds", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            
            
            
            /// if user update it and already got it , just return it to 'self.imgView.image'
            
            
            /// else if you could't find the edited image that means user select original image same is it without editing .
        } else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data = UIImagePNGRepresentation(orginalImage)
            
            if(AppManager.shared.canSendImage == true){
                AppManager.shared.canSendImage = false
                self.sentMessImageWith(data: data!, user: self.user)
                let when = DispatchTime.now() + 30
                DispatchQueue.main.asyncAfter(deadline: when) {
                    AppManager.shared.canSendImage = true
                }
            } else {
                // ALERT
                FCAlertView().showAlert(withTitle:"NOTIFICATION"
                    , withSubtitle: "Try again after 30 seconds", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            /// if user update it and already got it , just return it to 'self.imgView.image'.
            
        }
        else {
            print ("error")
            
        }
        
        /// if the request successfully done just dismiss
        picker.dismiss(animated: true) {
            self.tableViewMess.reloadData()
        }
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Action NavigationItem
fileprivate extension MessageViewVC {
    func prepareNavigationItem() {
        let menu = UIBarButtonItem(customView: menuButton)
        navigationItem.rightBarButtonItems = [menu]
    }
    func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.moreVertical)
        menuButton.frame.size   =   CGSize(width: 24, height: 24)
        menuButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        menuButton.tintColor    =   UIColor.white
    }
    @objc
    func handleNextButton() {
        FTPopOverMenu.showFromSenderFrame(senderFrame: CGRect.init(x: self.view.frame.width - 50, y: 20, width: 40, height: 40), with: listcontent, menuImageArray: listImg, done: { (index) in
            self.ActionWithIndex(index: index)
        }) {
            
        }
    }
    func ActionWithIndex(index : NSInteger){
        switch index {
        case 0:
            let param = [K_Id:AppManager.shared.user.idUser ?? 0,
                         M_ConversationsID: self.currentConversation.idConversation ?? -99,
                         K_AccessToken: AppManager.shared.user.access_token!] as [String : Any] as [String : Any] as [String : Any]
            UserSevice().getFriendChat(params: param as [String : AnyObject], completion: { (stt, responseData) in
                var data = responseData as! [String:AnyObject]
                if((data["status"] as! Int) == 200){
                    let user = data["message"] as! [String:AnyObject]
                    let friend = User(dict: user)
                    Utils.showProfile(forUser: friend, from: self)
                }
            })
            break
        case 1:
            let data = [M_ConversationsID: self.currentConversation.idConversation!,
                        C_Members: self.currentConversation.members!] as [String:Any]
            SocketConnect.shared.emit(on: "out", any: [data])
            break
            
        default: break
            
        }
    }
    func showViewProview(){
        let alert = FCAlertView()
        alert.addButton("Buy") {
        
        }
        alert.doneActionBlock {
            
        }
        alert.showAlert(withTitle: "Mua Coin", withSubtitle: "Bạn phải mất 1 coin để xem thông tin của người này", withCustomImage: UIImage.init(named: "inapp-purchase"), withDoneButtonTitle: "Cancel", andButtons:nil)
    }
}
// MARK: - Tableview Mess
extension MessageViewVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = MessageView.init(dict: MessViewData.object(at: indexPath.row) as! [String : AnyObject])
        let cell = loadCellFrom(tableView, cellIndexPath: indexPath, Withdata: data)
        cell.transform = tableViewMess.transform
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (isLoad == true) && (indexPath.row == MessViewData.count - 2){
            loadMessDataAt(index: currentIndex)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let WIDTH_AVATAR = 27
        let PADDING_AVATAR = 4
        self.typingView = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 32))
        self.typingView.backgroundColor = .clear
        self.typingView.transform = self.tableViewMess.transform
        
        self.avatarTyping = UIImageView(frame: CGRect(x: PADDING_AVATAR, y: PADDING_AVATAR, width: WIDTH_AVATAR, height: WIDTH_AVATAR))
        self.avatarTyping.image = UIImage(named: "avatar-default")
        self.avatarTyping.layer.cornerRadius = CGFloat(WIDTH_AVATAR/2)
        self.avatarTyping.layer.masksToBounds = true
        
        self.messageTyping = UIView(frame: CGRect(x: PADDING_AVATAR*2+WIDTH_AVATAR, y: PADDING_AVATAR/2, width: 50, height: 32))
        self.messageTyping.backgroundColor = FriendColor
        self.messageTyping.layer.cornerRadius = 15
        self.messageTyping.layer.masksToBounds = true
        
        let dots = TypingAnimation()
        dots.frame = CGRect(x: 12, y: 8, width: 40, height: 35)
        self.messageTyping.addSubview(dots)
        
        self.typingView.addSubview(self.messageTyping)
        self.typingView.addSubview(self.avatarTyping)
        
        return self.typingView
    }
    private func sentMessImageWith(data : Data, user : User){
        let date = Date()
        let tempID = self.tempIDforMessage()
        let mess = [
            M_SenderID          :   AppManager.shared.user.idUser!,
            M_Content           :   "http://google.com",
            M_TimeAT            :   date,
            M_Status            :   0,
            M_Type              :   2,
            M_IDMess            :   tempID,
            M_TempID            :   tempID,
            M_Data              :   data
            ] as [String : Any]
        MessViewData.insert(mess, at: 0)
        var image:UIImage!
        image = UIImage.init(data: data)
        image = Utils.resizeImage(image: image!, targetSize: CGSize(width: 200, height: 150))
        MLIMGURUploader.uploadPhoto(UIImagePNGRepresentation(image!), title: "test", description: "content", imgurClientID: IMGUR_CLIENT_ID, progress: { (percent) in
            DispatchQueue.main.async {
                // self.processBar.value = CGFloat(percent);
            }
        }, completionBlock: { (url) in
            if (url) != nil {
                print(url as Any)
                // SEND MESS
                let members = NSMutableArray()
                for i in 0..<self.currentConversation.members!.count{
                    var list = self.currentConversation.members![i] as! [String: AnyObject]
                    let m = [K_Id: list[K_Id],
                             K_NickName: list[K_NickName]]
                    members.add(m)
                }
                let mes = [M_SenderID: AppManager.shared.user.idUser!,
                               M_Content: url!,
                               M_Type: 2,
                               M_IDMess            :   tempID,
                               M_TempID            :   tempID,
                               M_ConversationsID: self.currentConversation.idConversation!,
                               C_Members: members] as [String : Any]
                SocketConnect.shared.sendMessageToServer(message: mes as [String : AnyObject]);
                // END SEND
            }
        }, failureBlock: { (rsponse, err, value) in
            print(err)
        })
        
    }
    private func sentMessText(content : String, user : User){
        let date = Date()
        let tempID = self.tempIDforMessage()
        let mess = [
            M_SenderID          :   AppManager.shared.user.idUser!,
            M_Content           :   content,
            M_TimeAT            :   date,
            M_Status            :   -1,
            M_Type              :   0,
            M_TempID            :  tempID,
            M_IDMess            :  tempID
            ] as [String : Any]
        MessViewData.insert(mess, at: 0)
    }
}
fileprivate extension MessageViewVC{
    func showTyping(show: Bool){
        if(show == true){
            self.tableViewMess.beginUpdates()
            UIView.animate(withDuration: 0.2, animations: {
                self.tableViewMess.sectionHeaderHeight = 40
                self.tableViewMess.layoutIfNeeded()
            })
            self.tableViewMess.endUpdates()
        } else {
            self.tableViewMess.beginUpdates()
            UIView.animate(withDuration: 0.2, animations: {
                self.tableViewMess.sectionHeaderHeight = 0
                self.tableViewMess.layoutIfNeeded()
            })
            self.tableViewMess.endUpdates()
        }
    }
    func checkMessType(data : MessageView) -> MessType{
        let type = data.type
        switch type {
        case 0?:
            return .MessTypeText
        case 1?:
            return .MessTypeSticker
        case 2?:
            return .MessTypeImage
        default:
            return .MessTypeText
        }
    }
    func loadCellFrom(_ tableview: UITableView, cellIndexPath: IndexPath, Withdata: MessageView) -> UITableViewCell{
        let type : MessType = checkMessType(data: Withdata)
        let cell = UITableViewCell()
        switch type{
        case .MessTypeText:
            return messCelltext(_:tableview, atIndexPath:cellIndexPath, mess: Withdata)
        case .MessTypeSticker:
            return messCellSticker(_:tableview, indexPath:cellIndexPath, mess: Withdata)
        case .MessTypeImage:
            return messCellImage(_:tableview, indexPath:cellIndexPath, mess: Withdata)
        default:
            return cell
        }
    }
    
    // MARK: Tin nhắn dạng Text
    func messCelltext(_ tableview: UITableView, atIndexPath: IndexPath, mess: MessageView) -> UITableViewCell{
        if mess.senderID == AppManager.shared.user.idUser {
            let cell : OutMessTypeText = tableview.dequeueReusableCell(withIdentifier: OutgoingTypeText, for: atIndexPath) as! OutMessTypeText
            if atIndexPath.row == 0{
                cell.getdataFrom(data: mess,showStatus: true)
            }else{
                cell.getdataFrom(data: mess,showStatus: false)
            }
            // SET STATUS MESSAGE
            if(atIndexPath.row == 0){
                if(mess.status == _Sending){
                    cell.statusMessage.isHidden = false
                    cell.statusMessage.image = UIImage(named: "sending")
                } else if(mess.status == _Sent){
                    cell.statusMessage.isHidden = false
                    cell.statusMessage.image = UIImage(named: "sent")
                } else if(mess.status == _Received){
                    cell.statusMessage.isHidden = false
                    cell.statusMessage.image = UIImage(named: "received")
                } else if(mess.status == _Seen){
                    cell.statusMessage.isHidden = false
                    cell.statusMessage.image = UIImage(named: "avatar-default")
                }
            } else {
                cell.statusMessage.isHidden = true
            }
            // END SET
            return cell
        }else{
            let cell : IncomMessTypeText = tableview.dequeueReusableCell(withIdentifier: IncomTypeText, for: atIndexPath) as! IncomMessTypeText
            if atIndexPath.row == 0{
                cell.getdataFrom(data: mess)
            }else{
                cell.getdataFrom(data: mess)
            }
            
            // CONFIG AVATAR
            let totalIndex = self.MessViewData.count-1
            if(atIndexPath.row < totalIndex){
                let message = MessageView(dict: self.MessViewData[atIndexPath.row+1] as! [String: AnyObject])
                if(message.senderID == AppManager.shared.user.idUser!){
                    cell.avatar.isHidden = false
                } else {
                    cell.avatar.isHidden = true
                }
            } else if(atIndexPath.row == self.MessViewData.count-1){
                cell.avatar.isHidden = false
            }
            return cell
        }
    }
    // MARK: Tin nhắn dạng ảnh
    func messCellImage(_ tableview: UITableView, indexPath: IndexPath, mess: MessageView) -> UITableViewCell{
        if (mess.senderID == AppManager.shared.user.idUser) {
            let cell : OutmessTypeImage = tableview.dequeueReusableCell(withIdentifier: OutgoingTypeImage, for: indexPath) as! OutmessTypeImage
            cell.currentConversation = self.currentConversation
            cell.index = indexPath.row
            if indexPath.row == 0{
                cell.getdataFrom(data: mess,showStatus: true)
            }else{
                cell.getdataFrom(data: mess,showStatus: false)
            }
            // SET STATUS MESSAGE
            if(indexPath.row == 0){
                if(mess.status == _Sending){
                    cell.statusMessage.isHidden = false
                    cell.statusMessage.image = UIImage(named: "sending")
                } else if(mess.status == _Sent){
                    cell.statusMessage.isHidden = false
                    cell.statusMessage.image = UIImage(named: "sent")
                } else if(mess.status == _Received){
                    cell.statusMessage.isHidden = false
                    cell.statusMessage.image = UIImage(named: "received")
                } else if(mess.status == _Seen){
                    cell.statusMessage.isHidden = false
                    cell.statusMessage.image = UIImage(named: "avatar-default")
                }
            } else {
                cell.statusMessage.isHidden = true
            }
            // END SET
            return cell
        }else{
            let cell : IncomMessImage = tableview.dequeueReusableCell(withIdentifier: IncomTypeImage, for: indexPath) as! IncomMessImage
            if indexPath.row == 0{
                cell.getdataFrom(data: mess)
            }else{
                cell.getdataFrom(data: mess)
            }
            // CONFIG AVATAR
            let totalIndex = self.MessViewData.count-1
            if(indexPath.row < totalIndex){
                let message = MessageView(dict: self.MessViewData[indexPath.row+1] as! [String: AnyObject])
                if(message.senderID == AppManager.shared.user.idUser!){
                    cell.avatar.isHidden = false
                } else {
                    cell.avatar.isHidden = true
                }
            } else if(indexPath.row == self.MessViewData.count-1){
                cell.avatar.isHidden = false
            }
            return cell
        }
    }
    // MARK: Tin nhắn dạng Sticker
    func messCellSticker(_ tableview: UITableView, indexPath: IndexPath, mess: MessageView) -> UITableViewCell{
        if mess.senderID == 1 {
            let cell : OutmessTypeSticker = tableview.dequeueReusableCell(withIdentifier: OutgoingTypeSticker, for: indexPath) as! OutmessTypeSticker
            return cell
        }else{
            let cell : IncomMessTypeSticker = tableview.dequeueReusableCell(withIdentifier: IncomTypeText, for: indexPath) as! IncomMessTypeSticker
            return cell
        }
    }
}
//MARK: KEYBOARD
// keyBoard
extension MessageViewVC {
    private func enableKeyboardHideOnTap(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil) // See 4.1
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil) //See 4.2
        
        // 3.1
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    //3.1
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //4.1
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let info = notification.userInfo!
        
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        print(keyboardFrame.size.height)
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations:
            {
                
                self.bottomKeyBoard.constant = keyboardFrame.size.height
                Defaul_KeyBoard = Double(keyboardFrame.size.height)
                self.isHiddenKeyboard = true
                self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration) { () -> Void in
            
            
            
        }
        
    }
    
    //4.2
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations:
            {
                if (self.txtzInput.becomeFirstResponder() == true && self.isHiddenKeyboard == true){
                    self.bottomKeyBoard.constant = 0
                    self.viewList.removeFromSuperview()
                    self.isHiddenKeyboard = false
                    self.view.layoutIfNeeded()
                }
        }, completion: nil)
        UIView.animate(withDuration: duration) { () -> Void in
            
            
        }
        
    }
    func keyboardCusstom(){
        btnMore.layer.cornerRadius = 12.5
        btnMore.layer.borderWidth  = 1.0
        btnMore.layer.borderColor   = AppBaseColor.cgColor
        btnMore.setBackgroundImage(Icon.addCircle, for: .normal)
        btnCamera.setImage(Icon.photoCamera, for: .normal)
        btnPhoto.setImage(Icon.photoLibrary, for: .normal)
        btnMore.tintColor   =   AppBaseColor
        viewTextinput.layer.cornerRadius    =   18.0
        viewTextinput.layer.borderWidth     =   0.5
        viewTextinput.layer.borderColor     =   AppBaseColor.cgColor
    }
}
