//
//  ConversationVC.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Material
import FCAlertView

class ConversationVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var constantBottomFloatingView: NSLayoutConstraint!
    @IBOutlet weak var tableViewConversation: UITableView!
    
    @IBOutlet weak var btnSreach: FABButton!
    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    fileprivate var fabButton: FABButton!
    
    var conversations = NSMutableArray()
    var isload = Bool()
    var cureentPage = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.prepareMenuButton()
        self.prepareSearchButton()
        self.prepareNavigationItem()
        
        
    }
    func loadat(index : Int){
        let params = [K_Id:AppManager.shared.user.idUser!,
                      K_Page: index,
                      K_PerPage: 10,
                      K_AccessToken: AppManager.shared.user.access_token!] as [String : Any]
        
        UserSevice().conversations(params: params as [String : AnyObject]) { (status, responseData) in
            var data = responseData as! [String:AnyObject]
            if((data["status"] as! Int) == 200){
                let array = data["message"] as! NSArray
                self.conversations.addObjects(from: NSMutableArray(array: array) as! [Any])
                self.isload = true
                self.cureentPage += 1
                self.tableViewConversation.reloadData()
            }else{
                self.isload = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewConversation.register(UINib.init(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: "ConversationCell")
        loadat(index: 0)
        view.backgroundColor = Color.grey.lighten5
        btnSreach.backgroundColor   =   UIColor.clear
        // Do any additional setup after loading the view.
        // MARK: Socket Message
        SocketConnect.shared.addHandleMessage { (data) in
            //print("-------------SOCKET MESSAGE---------- \n \(data)")
            for (i,element) in self.conversations.enumerated() {
                let conversation = Conversation(dict: element as! [String : AnyObject])
                if(conversation.idConversation == data[M_ConversationsID] as? Int ?? 0){
                    var replace = element as! [String : AnyObject]
                    replace[C_LastMessage] = data[M_Content] as AnyObject
                    replace[C_isRead] = 0 as AnyObject
                    replace[C_LastActionTime] = data[M_TimeAT] as AnyObject
                    self.conversations.replaceObject(at: i, with: replace)
                    let tmpArray = self.conversations.sorted(by: { (($0 as! [String:AnyObject])[C_LastActionTime]) as! Double > (($1 as! [String:AnyObject])[C_LastActionTime]) as! Double })
                    let tmpConversation = NSMutableArray(array: tmpArray)
                    self.conversations = tmpConversation
                    self.tableViewConversation.reloadData()
                }
            }
        }
        // SOCKET SEARCHINGS
        SocketConnect.shared.addHandleSearchings { (status, data) in
            if(status == true){
                let conversation = Conversation(dict: data)
                if searchBypoint{
                    AppManager.shared.user.point = AppManager.shared.user.point! - emtypoint
                    let params : [String:AnyObject] = [
                        K_UsersID           :   AppManager.shared.user.idUser as AnyObject,
                        K_AccessToken       :   AppManager.shared.user.access_token as AnyObject,
                        K_Point             :   AppManager.shared.user.point as AnyObject
                        
                    ]
                    UserSevice().updateWith(params: params, completion: { (success, data) in
                        if success{
                            emtypoint = 0
                            searchBypoint = false
                            self.pushToConversation(conversation: conversation)
                        }
                    })
                }else{
                    self.pushToConversation(conversation: conversation)
                }
            }
        }
    }
    func pushToConversation(conversation: Conversation){
        let Vc : MessageViewVC = Utils.MainStoryboard().instantiateViewController(withIdentifier: ID_messVC) as! MessageViewVC
        Vc.currentConversation = conversation
        Vc.navigationItem.title = conversation.name
        Vc.navigationItem.titleLabel.textColor =   UIColor.white
        Vc.navigationItem.detailLabel.textColor = UIColor.white
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK: SCROLL
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        if(contentYoffset < height/3){
            UIView.animate(withDuration: 0.2, animations: {
                self.constantBottomFloatingView.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.constantBottomFloatingView.constant = self.floatingView.frame.size.height
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBAction func SEARCHING(_ sender: UIButton) {
        let vc = Utils.MainStoryboard().instantiateViewController(withIdentifier: "SettingSearchVC")
        self.present(vc, animated: true, completion: nil)
    }
}


fileprivate extension ConversationVC{
    func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.frame.size   =   CGSize(width: 24, height: 24)
        menuButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        menuButton.tintColor    =   UIColor.white
    }
    
    func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star)
    }
    
    func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.settings)
        searchButton.frame.size   =   CGSize(width: 24, height: 24)
        searchButton.addTarget(self, action: #selector(handleSettingButton), for: .touchUpInside)
        
        searchButton.tintColor  =   UIColor.white
    }
    
    func prepareNavigationItem() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let viewNavi = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.45, height: (self.navigationController?.navigationBar.frame.size.height)!))
        let logo = UIImage(named: "logo-white")
        let imageView = UIImageView(frame: CGRect(x: 0, y: viewNavi.frame.size.height*0.1, width: viewNavi.frame.size.width, height: viewNavi.frame.size.height*0.8))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        viewNavi.addSubview(imageView)
        
        self.navigationItem.titleView = viewNavi
        
        let setting = UIBarButtonItem(customView: searchButton)
        let more = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItems = [more]
        navigationItem.rightBarButtonItems = [setting]
        //        navigationItem.centerViews = [viewNavi]
        //        navigationItem.leftViews = [menuButton]
        //        navigationItem.rightViews = [searchButton]
    }
    
    func prepareFABButton() {
        fabButton = FABButton(image: Icon.cm.moreHorizontal)
        fabButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        view.layout(fabButton).width(64).height(64).bottom(24).right(24)
        fabButton.tintColor = UIColor.white
    }
}
fileprivate extension ConversationVC {
    @objc
    func handleNextButton() {
        self.slideMenuController()?.openLeft()
    }
    @objc
    func handleSettingButton() {
        let vc : ListOnlineVC = Utils.MainStoryboard().instantiateViewController(withIdentifier: "ListOnlineVC") as! ListOnlineVC
        vc.navigationItem.title       =   "List Online"
        vc.navigationItem.titleLabel.textColor  =   UIColor.white
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension ConversationVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Vc : MessageViewVC = Utils.MainStoryboard().instantiateViewController(withIdentifier: ID_messVC) as! MessageViewVC
        let conversation = Conversation(dict: self.conversations[indexPath.row] as! [String : AnyObject])
        Vc.currentConversation = conversation
        Vc.navigationItem.title = conversation.name
        Vc.navigationItem.titleLabel.textColor =   UIColor.white
        Vc.navigationItem.detailLabel.textColor = UIColor.white
        self.navigationController?.pushViewController(Vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ConversationCell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        let conversation = Conversation(dict: self.conversations[indexPath.row] as! [String : AnyObject])
        cell.getdataToCell(data: conversation)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isload && (indexPath.row == self.conversations.count - 2 ){
            loadat(index: cureentPage)
        }
    }
}
