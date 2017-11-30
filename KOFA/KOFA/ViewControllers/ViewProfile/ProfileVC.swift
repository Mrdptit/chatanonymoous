//
//  ProfileVC.swift
//  KOFA
//
//  Created by may1 on 11/27/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Material
import AlamofireImage
class ProfileVC: UIViewController {
    var user : User!
    @IBOutlet weak var lblbirthday: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCreateTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnClose: FABButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitleName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupdata()
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        // Do any additional setup after loading the view.
    }
    func setupdata(){
        self.imgAvatar.af_setImage(withURL: URL(string: user.avatar!)!)
        self.lblTitleName.text      =   user.nickname
        self.lblName.text           =   user.nickname
        self.lblLocation.text       =   String(format: "%@, %@", user.city!,user.country!)
        self.lblCreateTime.text     =   user.createdAt
        self.lblGender.text         =   Utils.checkGenner(value: user.gender!)
        self.lblbirthday.text       =   user.birthday
    }
    func setupUI(){
        self.btnClose.layer.cornerRadius = self.btnClose.frame.size.height*0.5
        self.btnClose.layer.backgroundColor   =  backgroundColor.cgColor
        self.btnClose.setBackgroundImage(Icon.cm.close, for: .normal)
        self.imgAvatar.layer.cornerRadius          =   imgAvatar.frame.size.height*0.5
        self.imgAvatar.layer.borderColor           =   borderColor.cgColor
        self.imgAvatar.layer.borderWidth           =    2.0
        
        self.viewContent.layer.cornerRadius        =    8.0
        self.viewContent.layer.borderColor         =    borderColor.cgColor
        self.viewContent.layer.borderWidth         =    2.0
        self.viewContent.clipsToBounds             =    true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        
            self.dismiss(animated: true)
            
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
