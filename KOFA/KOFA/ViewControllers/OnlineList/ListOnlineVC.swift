//
//  ListOnlineVC.swift
//  KOFA
//
//  Created by may1 on 11/23/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import FCAlertView
let CardCell    = "CardInfo"


class ListOnlineVC: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    var onlineList = NSMutableArray()
    // popMenu
    let listcontent = ["View Profile","Chat"]
    let listImg     = ["ic_profile","ic_chat"]
    var isload = Bool()
    var page : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func loaddataIndex(index : Int){
        let params = [K_Id: AppManager.shared.user.idUser!,
                      K_Page: index,
                      K_PerPage: 10,
                      K_AccessToken: AppManager.shared.user.access_token!] as [String: Any]
        
        UserSevice().online(params: params as [String : AnyObject]) { (status, responseData) in
            var data = responseData as! [String:AnyObject]
            if((data["status"] as! Int) == 200){
                self.isload = true
                self.page += 1
                let array = data["message"] as! NSArray
                self.onlineList = NSMutableArray(array: array)
                self.tableview.reloadData()
            }else{
                self.isload = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loaddataIndex(index: page)
        tableview.register(UINib.init(nibName: "CardInfo", bundle: nil), forCellReuseIdentifier: CardCell)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ListOnlineVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.onlineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CardInfo = tableview.dequeueReusableCell(withIdentifier: CardCell, for: indexPath) as! CardInfo
        let user = User(dict: self.onlineList.object(at: indexPath.row) as! [String : AnyObject])
        cell.card.toolbar?.title = "Stranger \(self.random(self.onlineList.count*2))"
        cell.card.toolbar?.detail = "\(user.city ?? "Unknown") / \(user.country ?? "Unknown") - \(user.country_code ?? "Unknown")"
        cell.dateLabel.text = "\(Utils.checkGenner(value: user.gender ?? 0)) - \(Utils.birthdayToAge(value: user.birthday ?? "01/01/1990")) years old"
        cell.moreButton.tag = indexPath.row
        cell.moreButton.addTarget(self, action: #selector(selectedPopMenu), for: UIControlEvents.touchDown)
        
        return cell
    }
    @objc func selectedPopMenu(sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let popover = FTConfiguration.shared
        popover.menuWidth = self.view.frame.width*0.5
        popover.backgoundTintColor  =   .lightGray
        popover.textColor           =   .white
        
        FTPopOverMenu.showForSender(sender: sender, with:listcontent, menuImageArray: listImg, done: { (index) in
            let alert = FCAlertView()
            alert.addButton("Ok") {
                let friend = User(dict: self.onlineList.object(at: sender.tag) as! [String : AnyObject])
                if AppManager.shared.user.point ?? 0 >= 3{
                    AppManager.shared.user.point = AppManager.shared.user.point! - 3
                    let params : [String:AnyObject] = [
                        K_UsersID           :   AppManager.shared.user.idUser as AnyObject,
                        K_AccessToken       :   AppManager.shared.user.access_token as AnyObject,
                        K_Point             :   AppManager.shared.user.point as AnyObject
                        
                    ]
                    UserSevice().updateWith(params: params, completion: { (success, data) in
                        if success{
                            if index == 0 {
                                Utils.showProfile(forUser: friend, from: self)
                            }else{
                                
                            }
                        }else{
                            FCAlertView().showAlert(withTitle: "Error!!", withSubtitle: "Can't connect to sever", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
                            
                        }
                    })
                    
                    
                }else{
                    FCAlertView().showAlert(withTitle: "Warnning!!", withSubtitle: "You don't have enough coin", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
                    
                }
            }
            alert.showAlert(withTitle: "Warnning!!", withSubtitle: "You will be subtract 3 coin", withCustomImage: nil, withDoneButtonTitle: "Cancel", andButtons: nil)
        }) {
            
        }
        
        print("heheee \(sender.tag)")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isload && (indexPath.row == self.onlineList.count-1 ){
            loaddataIndex(index: self.page)
        }
    }
    func random(_ n:Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(n)))
    }
}
