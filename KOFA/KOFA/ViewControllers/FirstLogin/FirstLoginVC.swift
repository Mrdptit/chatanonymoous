//
//  FirstLoginVC.swift
//  KOFA
//
//  Created by may1 on 11/15/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import EAIntroView
import FacebookLogin
import FacebookCore
import SVProgressHUD
import CoreLocation
import SlideMenuControllerSwift

class FirstLoginVC: UIViewController ,EAIntroDelegate, LocationServicesDelegate{
    func tracingLocation(_ currentLocation: CLLocation) {
        manager.getAddressFromLocation(location: manager.currentLocation!) { (status, dict) in
            if let address = dict{
                self.dictionaryLocation = address
            }
        }
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        print(error)
    }
    
    func tracingHeading(_ currentHeading: CLHeading) {
        print(currentHeading)
    }
    
    let manager = LocationServices.sharedInstance
    var dictionaryLocation: NSDictionary!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIntro()
        manager.delegate = self
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupIntro() {
        let font40 = [ NSAttributedStringKey.font: UIFont(name: "Roboto-Bold", size: 40.0)! ]
        let font30 = [ NSAttributedStringKey.font: UIFont(name: "Roboto-Medium", size: 30.0)! ]
        
        let page1 = EAIntroPage()
        let view1 = UIView()
        view1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        view1.backgroundColor = .clear
        //        TITLE 1
        let title1 = UILabel()
        let full1 = NSMutableAttributedString(string: "CHAT\n", attributes: font40 )
        let subTitle1 = NSAttributedString(string: "with strangers", attributes: font30)
        full1.append(subTitle1)
        title1.attributedText = full1
        title1.numberOfLines = 0
        title1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.3)
        title1.textAlignment = .center
        title1.textColor = .white
        //        IMAGE 1
        let image1 = UIImageView()
        image1.frame = CGRect(x: self.view.frame.size.width*0.15, y: self.view.frame.size.height*0.3, width: self.view.frame.size.width*0.7, height: self.view.frame.size.height*0.25)
        image1.image = UIImage.init(named: "step1-img")
        image1.contentMode = UIViewContentMode.scaleAspectFit
        //        DESCRIPTION 1
        let description1 = UILabel()
        description1.text = "The information entered by the user,\nwe allow you to select the\nappopriate person only by setting\na search filter."
        description1.font = UIFont.systemFont(ofSize: 19)
        description1.textColor = .white
        description1.textAlignment = .center
        description1.numberOfLines = 0
        description1.frame = CGRect(x: 0, y: self.view.frame.size.height*0.5, width: self.view.frame.size.width, height: self.view.frame.size.height*0.45)
        
        view1.addSubview(description1)
        view1.addSubview(image1)
        view1.addSubview(title1)
        page1.customView = view1
        
        
        let page2 = EAIntroPage()
        let view2 = UIView()
        view2.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        view2.backgroundColor = .clear
        //        TITLE 2
        let title2 = UILabel()
        let full2 = NSMutableAttributedString(string: "FIND\n", attributes: font40 )
        let subTitle2 = NSAttributedString(string: "with powerful filters", attributes: font30)
        full2.append(subTitle2)
        title2.attributedText = full2
        title2.numberOfLines = 0
        title2.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height*0.3)
        title2.textAlignment = .center
        title2.textColor = .white
        //        IMAGE 2
        let image2 = UIImageView()
        image2.frame = CGRect(x: self.view.frame.size.width*0.15, y: self.view.frame.size.height*0.3, width: self.view.frame.size.width*0.7, height: self.view.frame.size.height*0.25)
        image2.image = UIImage.init(named: "step2-img")
        image2.contentMode = UIViewContentMode.scaleAspectFit
        //        DESCRIPTION 2
        let description2 = UILabel()
        description2.text = "Filter the user around you to get\n for you acquainted with high-level\n verify users."
        description2.font = UIFont.systemFont(ofSize: 19)
        description2.textColor = .white
        description2.textAlignment = .center
        description2.numberOfLines = 0
        description2.frame = CGRect(x: 0, y: self.view.frame.size.height*0.5, width: self.view.frame.size.width, height: self.view.frame.size.height*0.45)
        
        view2.addSubview(description2)
        view2.addSubview(image2)
        view2.addSubview(title2)
        page2.customView = view2
        
        
        
        let intro = EAIntroView(frame: CGRect(x:0, y:0, width: self.view.frame.size.width, height: 0.9*self.view.frame.size.height), andPages: [page1,page2])
        intro?.bgImage = UIImage.init(named: "bg-login")
        intro?.swipeToExit = false
        intro?.delegate = self
        
        intro?.skipButton   =   UIButton()
        intro?.show(in: self.view, animateDuration: 0.3)
        
        let btnLogin    = UIButton()
        btnLogin.addTarget(self,action: #selector(self.login), for: UIControlEvents.touchUpInside)
        btnLogin.frame  =   CGRect(x: 0, y: 0.9*self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height*0.1)
        btnLogin.setTitle("LOGIN WITH FACEBOOK", for: UIControlState.normal)
        btnLogin.setTitleColor(AppBaseColor, for: UIControlState.normal)
        btnLogin.titleLabel?.font = UIFont.init(name: "Roboto-Medium", size: 22)
        btnLogin.backgroundColor    =   UIColor.white
        self.view.addSubview(btnLogin)
    }
    @objc func login(){
        if(CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined){
            manager.requestPermission()
        } else {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            
            let loginManager    = LoginManager()
            loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: self) { (LoginResult) in
                SVProgressHUD.show()
                switch LoginResult{
                case .failed(let error):
                    blurEffectView.isHidden = true
                    print(error)
                case .cancelled:
                    blurEffectView.isHidden = true
                    print("user cancel")
                case.success(grantedPermissions: let grantedPermissions, declinedPermissions: let declinepermission, token: let accesstoken):
                    print("accessToken:  \(accesstoken)")
                    print("declinepermission:  \(declinepermission)")
                    print("1: \(grantedPermissions)")
                    //                GRAPH
                    let connection = GraphRequestConnection()
                    connection.add(GraphRequest(graphPath: "/me?fields=id,name,email,birthday,cover,picture.type(large),gender")) { httpResponse, result in
                        switch result {
                        case .success(let response):
                            let dictionaryFacebook = response.dictionaryValue! as [String:AnyObject]
                            let avatar = dictionaryFacebook["picture"]!["data"]! as! [String:AnyObject]
                            // BIRTHDAY
                            var birthday: String {
                                let str = "0"
                                guard let bd = dictionaryFacebook["birthday"] else {
                                    return str
                                }
                                return bd as! String
                            }
                            // GENDER
                            var genderText: String {
                                let str = "0"
                                guard let bd = dictionaryFacebook["gender"] else {
                                    return str
                                }
                                return bd as! String
                            }
                            var gender:Int!
                            if(genderText == "female"){
                                gender = 2
                            } else {
                                gender = 1
                            }
                            // EMAIL
                            var emailText: String {
                                let str = "0"
                                guard let bd = dictionaryFacebook["email"] else {
                                    return str
                                }
                                return bd as! String
                            }
                            // AVATAR
                            var avatarImage: String {
                                let str = ""
                                guard let bd = avatar["url"] else {
                                    return str
                                }
                                return bd as! String
                            }
                            // COVER
                            var coverImage: String {
                                let str = ""
                                let cover = (dictionaryFacebook["cover"] as? Dictionary) ?? ["source":""]
                                guard let bd = cover["source"] else {
                                    return str
                                }
                                return bd
                            }
                            let object = [K_FacebookID:dictionaryFacebook["id"]!,
                                          K_Email:emailText,
                                          K_NickName:dictionaryFacebook["name"]!,
                                          K_Cover:coverImage,
                                          K_Avatar:avatarImage,
                                          K_Birthday: birthday,
                                          K_Gender: gender,
                                          K_FacebookToken: accesstoken.authenticationToken,
                                          K_Longitude: self.manager.currentLocation?.coordinate.longitude ?? 0,
                                          K_Latitude: self.manager.currentLocation?.coordinate.latitude ?? 0
                                ] as [String : Any]
                            print(dictionaryFacebook)
                            let paramLogin = [K_FacebookID:dictionaryFacebook["id"]!,
                                              K_FacebookToken: accesstoken.authenticationToken] as [String : Any]
                            UserSevice().signinWith(params: paramLogin as [String : AnyObject], completion: { (success, res) in
                                var responseData = res as! [String:AnyObject]
                                if((responseData["status"] as! Int) == 200){
                                    let dict = responseData["message"]
                                    let user = User(dict: dict as! [String : AnyObject])
                                    
                                    AppManager.shared.user = user
                                    AppManager.shared.logged = true
                                    AppManager.shared.user.saveUser(dict: dict as! [String : AnyObject])
                                    SocketConnect.shared.connectToServer()
                                    let vc = Utils.MainStoryboard().instantiateViewController(withIdentifier: "RootNavigation")
                                    let vc1 = Utils.MainStoryboard().instantiateViewController(withIdentifier: "MenuVC")
                                    let slideMenuController = SlideMenuController(mainViewController: vc, leftMenuViewController: vc1)
                                    if let application = UIApplication.shared.delegate {
                                        if let window = application.window {
                                            window?.rootViewController = slideMenuController
                                            window?.makeKeyAndVisible()
                                        }
                                    }
                                    blurEffectView.isHidden = true
                                    SVProgressHUD.dismiss()
                                    
                                } else {
                                    blurEffectView.isHidden = true
                                    SVProgressHUD.dismiss()
                                    let vc = Utils.MainStoryboard().instantiateViewController(withIdentifier: "InfoVC") as! InfoVC
                                    vc.params = object as [String : AnyObject]
                                    vc.location = self.dictionaryLocation
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            });
                            
                        case .failed(let error):
                            blurEffectView.isHidden = true
                            print("Graph Request Failed: \(error)")
                        }
                    }
                    connection.start()
                }
                
            }
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
    
}
