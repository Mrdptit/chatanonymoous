//
//  InfoVC.swift
//  KOFA
//
//  Created by may1 on 11/25/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

import SVProgressHUD
import SlideMenuControllerSwift
import Material
import FCAlertView
class InfoVC: UIViewController, SambagDatePickerViewControllerDelegate, LocationcontryDelegate {
    
    @IBOutlet weak var txfName: TextField!
    
    @IBOutlet weak var txfEmail: TextField!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnUpdate: RaisedButton!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var viewLineFemale: UIView!
    @IBOutlet weak var imgFemale: UIImageView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var viewLineMale: UIView!
    @IBOutlet weak var imgMale: UIImageView!
    var params:[String:AnyObject]!
    var location:NSDictionary!
    var countries = AppManager().countries()
    var currentCountry: NSDictionary!
    
    var currentCountryText: String!
    var currentBirthdayText: String!
    var currentGenderInt:Int!
    var currentFBID:String!
    var currentFBToken:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFileEmail()
        prepareTextfileName()
        configdata()
        setupMore()
        self.navigationController?.setToolbarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    @IBAction func btnFemale(_ sender: Any) {
        SetupViewGender(male: false)
        self.currentGenderInt = 2
    }
    
    @IBAction func btnMale(_ sender: Any) {
        SetupViewGender(male: true)
        self.currentGenderInt = 1
    }
    @IBAction func btnDate(_ sender: Any) {
        
        let vc = SambagDatePickerViewController()
        vc.theme = .light
        vc.delegate = self as SambagDatePickerViewControllerDelegate
        present(vc, animated: true, completion: nil)
    }
    @IBAction func btnUpdate(_ sender: Any) {
        sigin()
    }
    @IBAction func btnCountry(_ sender: Any) {
        let vc = LocationCountyVC()
        vc.delegate = self
        vc.checkLocation    =   lblCountry.text!
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true) {
            
        }
    }
    func selecdAt(at index: Int, with content: String) {
        self.lblCountry.text    =   content
        self.currentCountryText =   content
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func configdata(){
        
        if let address = self.location, let country = address["CountryCode"] as? String {
            for i in 0..<self.countries.count{
                var ctry = self.countries[i] as! [String:AnyObject]
                if(ctry["code"] as! String == country){
                    self.lblCountry.text = ctry["name"] as? String
                    self.currentCountryText = ctry["name"] as! String
                }
            }
        }
        //
        if (self.params["birthday"] as! String == "0") {
            
            self.lblDate.text = "01/01/1990"
            self.currentBirthdayText = "01/01/1990"
        } else {
            self.lblDate.text = self.params["birthday"] as? String
            self.currentBirthdayText = self.params["birthday"] as! String
        }
        //
        if (self.params["email"] as! String == "0") {
            
            self.txfEmail.text = ""
            self.txfEmail.detail    =   "Email"
            
        } else {
            self.txfEmail.text = self.params["email"] as? String
           
        }
        self.txfName.text = self.params["nickname"] as? String
        
        if(self.params["gender"] as! Int == 1){
            self.currentGenderInt = 1
            SetupViewGender(male: true)
        } else {
            SetupViewGender(male: false)
            self.currentGenderInt = 2
        }
        self.currentFBID = self.params[K_FacebookID] as? String
        self.currentFBToken = self.params[K_FacebookToken] as? String
    }
}
// MARK :  Button
extension InfoVC {
    // MARK : Date Button
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        self.lblDate.text   =    String(describing: result)
        self.currentBirthdayText = String(describing: result)
        viewController.dismiss(animated: true, completion: nil)
        
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    //
    private func sigin(){
        if (txfName.text! == "") || (txfEmail.text! == "") || !isValidEmail(testStr: txfEmail.text!) || (lblCountry.text! == "Country")  {
            FCAlertView().showAlert(withTitle: "Error", withSubtitle: "You are not have enough information", withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
            return
        }
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        SVProgressHUD.show()
        
        
        self.params[K_Birthday] = self.lblDate.text as AnyObject
        self.params[K_Country] = self.lblCountry.text as AnyObject
        self.params[K_Gender] = self.currentGenderInt as AnyObject
        self.params[K_NickName] = self.txfName.text as AnyObject
        self.params[K_Email] = self.txfEmail.text as AnyObject
        
        if let address = self.location, let country = address["CountryCode"] as? String, let city = address["City"] as? String{
            self.params[K_City] = city as AnyObject
            self.params[K_CountryCode] = country as AnyObject
        }
        
        let paramsLogin = [K_FacebookID: self.currentFBID as AnyObject,
                           K_FacebookToken: self.currentFBToken as AnyObject]
        
        self.params.removeValue(forKey: K_FacebookToken)
        
        UserSevice().signupWith(params: self.params) { (status, response) in
            var responseSignup = response as! [String:AnyObject]
            if((responseSignup["status"] as! Int) == 200){
                UserSevice().signinWith(params: paramsLogin, completion: { (logged, res) in
                    var responseSignin = res as! [String:AnyObject]
                    if((responseSignin["status"] as! Int) == 200){
                        let dict = responseSignin["message"]
                        let user = User(dict: dict as! [String : AnyObject])
                        AppManager.shared.user = user
                        AppManager.shared.user.saveUser(dict: dict as! [String : AnyObject])
                        AppManager.shared.logged = true
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
                        FCAlertView().showAlert(withTitle: "Error", withSubtitle: responseSignin["message"] as! String, withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
                        // ALERT FAILED
                    }
                })
            } else {
                blurEffectView.isHidden = true
                SVProgressHUD.dismiss()
                FCAlertView().showAlert(withTitle: "Error", withSubtitle: responseSignup["message"] as! String, withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
                
                // ALERT FAILED
            }
        }
        
        
    }
}
// MARK : Setup UI
extension InfoVC: TextFieldDelegate{
    private func setupMore(){
        btnUpdate.layer.cornerRadius    =   btnUpdate.frame.size.height*0.5
        btnUpdate.layer.borderColor     =   UIColor.white.cgColor
        btnUpdate.layer.borderWidth     =   2.0
        btnUpdate.backgroundColor       =   AppBaseColor
    }
    private func SetupViewGender(male : Bool) {
        if male == true {
            self.imgMale.image                  =   UIImage.init(named: "ic_checked")
            self.viewLineMale.backgroundColor   =   AppBaseColor
            self.imgFemale.image                =   UIImage.init(named: "ic_unchecked")
            self.viewLineFemale.backgroundColor =   UIColor.gray
        }else{
            self.imgMale.image                  =   UIImage.init(named: "ic_unchecked")
            self.viewLineMale.backgroundColor   =   UIColor.gray
            self.imgFemale.image                =   UIImage.init(named: "ic_checked")
            self.viewLineFemale.backgroundColor =   AppBaseColor
        }
    }
    private func prepareTextfileName(){
        txfName.placeholder = "Name"
        txfName.isClearIconButtonEnabled = true
        txfName.delegate = self
        txfName.isPlaceholderUppercasedWhenEditing = false
        txfName.placeholderAnimation = .default
        
        // Set the colors for the emailField, different from the defaults.
        txfName.placeholderNormalColor = Color.grey.lighten1
        txfName.placeholderActiveColor = AppBaseColor
        txfName.dividerNormalColor = Color.grey.lighten1
        txfName.dividerActiveColor = AppBaseColor
        //Set the text inset
        txfName.textInset = 10
        
        let leftView = UIImageView()
        leftView.image = UIImage.init(named: "ic_name-gr")
        txfName.leftView = leftView
    }
    private func prepareTextFileEmail(){
        txfEmail.placeholder = "Email"
        txfEmail.detail = ""
        txfEmail.isClearIconButtonEnabled = true
        txfEmail.delegate = self
        txfEmail.isPlaceholderUppercasedWhenEditing = false
        txfEmail.placeholderAnimation = .default
        
        // Set the colors for the emailField, different from the defaults.
        txfEmail.placeholderNormalColor = Color.grey.lighten1
        txfEmail.placeholderActiveColor = AppBaseColor
        txfEmail.dividerNormalColor = Color.grey.lighten1
        txfEmail.dividerActiveColor = AppBaseColor
        // Set the text inset
        txfEmail.textInset = 10
        
        let leftView = UIImageView()
        leftView.image = UIImage.init(named: "ic_gmail-gr")
        txfEmail.leftView = leftView
    }
}
// MARK : Check DATA
extension InfoVC {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        if !isValidEmail(testStr: txfEmail.text!){
            txfEmail.detail     =   "Error, incorrect email"
            txfEmail.detailColor    =  .red
            self.btnUpdate.isEnabled    =   false
        }else{
         txfEmail.detail     =  ""
            self.btnUpdate.isEnabled    =   true
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = true
        return true
    }
}
