//
//  InfoLoginVC.swift
//  KOFA
//
//  Created by may10 on 11/17/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import SVProgressHUD
import SlideMenuControllerSwift

class InfoLoginVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var constantBottomPicker: NSLayoutConstraint!
    @IBOutlet weak var constantBottomDatePicker: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtNickname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var lbBirthday: UILabel!
    
    var params:[String:AnyObject]!
    var location:NSDictionary!
    var countries = AppManager().countries()
    var currentCountry: NSDictionary!
    
    var currentCountryText: String!
    var currentBirthdayText: String!
    var currentGenderInt:Int!
    var currentFBID:String!
    var currentFBToken:String!
    
    
    @IBOutlet weak var topMarginView: NSLayoutConstraint!

    override func viewDidLayoutSubviews() {
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let viewNavi = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.45, height: (self.navigationController?.navigationBar.frame.size.height)!))
        let logo = UIImage(named: "logo-white")
        let imageView = UIImageView(frame: CGRect(x: 0, y: viewNavi.frame.size.height*0.1, width: viewNavi.frame.size.width, height: viewNavi.frame.size.height*0.8))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        viewNavi.addSubview(imageView)
        
        self.navigationItem.titleView = viewNavi
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.txtCountry.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = AppBaseColor
        
        self.datePicker.backgroundColor = AppBaseColor
        self.datePicker.setValue(UIColor.white, forKey: "textColor")
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(InfoLoginVC.onChangeDatePicker), for: UIControlEvents.valueChanged)
        
        configdata()
        // Do any additional setup after loading the view.
    }
    private func configdata(){
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -13
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        self.datePicker.minimumDate = minDate
        self.datePicker.maximumDate = maxDate
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickOut))
        self.view.addGestureRecognizer(tap)
        
        self.constantBottomPicker.constant = -self.pickerView.frame.size.height
        self.constantBottomDatePicker.constant = -self.datePicker.frame.size.height
        
        if let address = self.location, let country = address["CountryCode"] as? String {
            for i in 0..<self.countries.count{
                var ctry = self.countries[i] as! [String:AnyObject]
                if(ctry["code"] as! String == country){
                    self.txtCountry.text = ctry["name"] as? String
                    self.currentCountryText = ctry["name"] as! String
                }
            }
        }
        //
        if (self.params["birthday"] as! String == "0") {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 10
            let attString = NSMutableAttributedString(string: "01/01/1990")
            attString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attString.length))
            self.lbBirthday.attributedText = attString
            self.currentBirthdayText = "01/01/1990"
        } else {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 10
            let attString = NSMutableAttributedString(string: self.params["birthday"] as! String)
            attString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attString.length))
            self.lbBirthday.attributedText = attString
            self.currentBirthdayText = self.params["birthday"] as! String
        }
        //
        self.txtNickname.text = self.params["nickname"] as? String
        self.txtEmail.text = self.params["email"] as? String
        if(self.params["gender"] as! Int == 1){
            self.currentGenderInt = 1
            switchButton(male: true)
        } else {
            switchButton(male: false)
            self.currentGenderInt = 2
        }
        self.currentFBID = self.params[K_FacebookID] as? String
        self.currentFBToken = self.params[K_FacebookToken] as? String
    }
    @objc func onChangeDatePicker(datePicker: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 10
        let attString = NSMutableAttributedString(string: selectedDate)
        attString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attString.length))
        self.lbBirthday.attributedText = attString
        
        self.currentBirthdayText = selectedDate
    }
    @objc func clickOut(){
        UIView.animate(withDuration: 0.2) {
            self.constantBottomPicker.constant = -self.pickerView.frame.size.height
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.2) {
            self.constantBottomDatePicker.constant = -self.datePicker.frame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let tmp:NSDictionary = self.countries[row] as! NSDictionary;
        let title:String = tmp["name"] as! String;
        let white = [NSAttributedStringKey.foregroundColor : UIColor.white]
        let titleText = NSAttributedString(string: title, attributes: white)
        
        return titleText;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentCountry = self.countries[row] as! NSDictionary
        let title:String = self.currentCountry["name"] as! String;
        self.txtCountry.text = title
        self.currentCountryText = title
        print(self.currentCountry);
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func configUI(){
        let padding:CGFloat = 10.0
        self.txtNickname.setLeftPaddingPoints(padding)
        self.txtEmail.setLeftPaddingPoints(padding)
        
        self.txtNickname.setRightPaddingPoints(padding)
        self.txtEmail.setRightPaddingPoints(padding)
        
        self.txtCountry.setLeftPaddingPoints(padding)
        self.txtCountry.setRightPaddingPoints(padding)
        
        self.txtNickname.configTextfield()
        self.txtEmail.configTextfield()
        self.txtCountry.configTextfield()
        self.lbBirthday.configLabel()
        
        self.btnSignup.backgroundColor = AppBaseColor
        self.btnSignup.layer.cornerRadius = self.btnSignup.frame.size.height/2
        self.btnSignup.layer.masksToBounds = true
    }
    
    func switchButton(male: Bool){
        if(male == true){
            self.btnMale.isSelected = true
            self.btnFemale.isSelected = false
//
            self.btnMale.layer.masksToBounds = true
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.btnMale.frame
            rectShape.position = self.btnMale.center
            rectShape.path = UIBezierPath(roundedRect: self.btnMale.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.btnMale.frame.size.height/2, height: self.btnMale.frame.size.height/2)).cgPath
            self.btnMale.layer.mask = rectShape
            
            let borderLayer = CAShapeLayer()
            borderLayer.path = rectShape.path
            borderLayer.fillColor = AppBaseColor.cgColor
            borderLayer.frame = self.btnMale.bounds
            borderLayer.strokeColor = AppBaseColor.cgColor
            borderLayer.lineWidth = 4.0
            self.btnMale.layer.addSublayer(borderLayer)
            
            let title = self.btnMale.titleLabel
            title?.textColor = .white
            self.btnMale.addSubview(title!)
//
            self.btnFemale.layer.masksToBounds = true
            let rectShape2 = CAShapeLayer()
            rectShape2.bounds = self.btnFemale.frame
            rectShape2.position = self.btnFemale.center
            rectShape2.path = UIBezierPath(roundedRect: self.btnFemale.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.btnFemale.frame.size.height/2, height: self.btnFemale.frame.size.height/2)).cgPath
            self.btnFemale.layer.mask = rectShape2
            
            let borderLayer2 = CAShapeLayer()
            borderLayer2.path = rectShape2.path
            borderLayer2.fillColor = UIColor.white.cgColor
            borderLayer2.frame = self.btnFemale.bounds
            borderLayer2.strokeColor = AppBaseColor.cgColor
            borderLayer2.lineWidth = 4.0
            self.btnFemale.layer.addSublayer(borderLayer2)
            
            let t2 = UILabel()
            t2.frame = self.btnFemale.bounds
            t2.text = self.btnFemale.titleLabel?.text
            t2.textColor = AppBaseColor
            t2.textAlignment = .center
            self.btnFemale.addSubview(t2)
            
        } else {
            self.btnMale.isSelected = false
            self.btnFemale.isSelected = true
            //
            self.btnMale.layer.masksToBounds = true
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.btnMale.frame
            rectShape.position = self.btnMale.center
            rectShape.path = UIBezierPath(roundedRect: self.btnMale.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.btnMale.frame.size.height/2, height: self.btnMale.frame.size.height/2)).cgPath
            self.btnMale.layer.mask = rectShape
            
            let borderLayer = CAShapeLayer()
            borderLayer.path = rectShape.path
            borderLayer.fillColor = UIColor.white.cgColor
            borderLayer.frame = self.btnMale.bounds
            borderLayer.strokeColor = AppBaseColor.cgColor
            borderLayer.lineWidth = 4.0
            self.btnMale.layer.addSublayer(borderLayer)
            
            let t2 = UILabel()
            t2.frame = self.btnMale.bounds
            t2.text = self.btnMale.titleLabel?.text
            t2.textColor = AppBaseColor
            t2.textAlignment = .center
            self.btnMale.addSubview(t2)
            //
            self.btnFemale.layer.masksToBounds = true
            let rectShape2 = CAShapeLayer()
            rectShape2.bounds = self.btnFemale.frame
            rectShape2.position = self.btnFemale.center
            rectShape2.path = UIBezierPath(roundedRect: self.btnFemale.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.btnFemale.frame.size.height/2, height: self.btnFemale.frame.size.height/2)).cgPath
            self.btnFemale.layer.mask = rectShape2
            
            let borderLayer2 = CAShapeLayer()
            borderLayer2.path = rectShape2.path
            borderLayer2.fillColor = AppBaseColor.cgColor
            borderLayer2.frame = self.btnFemale.bounds
            borderLayer2.strokeColor = AppBaseColor.cgColor
            borderLayer2.lineWidth = 4.0
            self.btnFemale.layer.addSublayer(borderLayer2)
            
            let title2 = self.btnFemale.titleLabel
            title2?.textColor = .white
            self.btnFemale.addSubview(title2!)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, delay: 0.05, options: .allowAnimatedContent, animations: {
            self.topMarginView.constant = -80
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, delay: 0.05, options: .allowAnimatedContent, animations: {
            self.topMarginView.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func SIGNUP_NOW(_ sender: UIButton) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        SVProgressHUD.show()
        
        
        self.params[K_Birthday] = self.currentBirthdayText as AnyObject
        self.params[K_Country] = self.currentCountryText as AnyObject
        self.params[K_Gender] = self.currentGenderInt as AnyObject
        self.params[K_NickName] = self.txtNickname.text as AnyObject
        self.params[K_Email] = self.txtEmail.text as AnyObject
        
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
                        // ALERT FAILED
                    }
                })
            } else {
                // ALERT FAILED
            }
        }
        
        
    }
    
    @IBAction func BIRTHDAT_PICKER(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.constantBottomDatePicker.constant = 0
            self.constantBottomPicker.constant = -self.pickerView.frame.size.height
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func COUNTRY_PICKER(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.constantBottomPicker.constant = 0
            self.constantBottomDatePicker.constant = -self.datePicker.frame.size.height
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func SWITCH_GENDER(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            switchButton(male: true)
            self.currentGenderInt = 1
            break
        case 1:
            switchButton(male: false)
            self.currentGenderInt = 2
            break
        default:
            break
        }
    }
}
