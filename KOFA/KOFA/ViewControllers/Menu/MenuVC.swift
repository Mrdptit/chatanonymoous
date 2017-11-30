//
//  MenuVC.swift
//  KOFA
//
//  Created by may1 on 11/22/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import AlamofireImage
import Material
import FCAlertView
import SVProgressHUD
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
class MenuVC: UIViewController,UIPickerViewAccessibilityDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    let pickerImage = UIImagePickerController()
    var changeInfo  =   Bool()
    @IBOutlet weak var btnChangeName: FlatButton!
    @IBOutlet weak var btnChangeAvatar: FlatButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblNumberPoint: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBuyPoint: RaisedButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height*0.5;
        imgAvatar.layer.borderColor =  AppBaseColor.cgColor
        imgAvatar.layer.borderWidth =   2.0
        
        btnChangeAvatar.layer.cornerRadius = imgAvatar.layer.cornerRadius
        imgAvatar.af_setImage(withURL: URL.init(string: AppManager.shared.user.avatar!)!)
        lblName.text = AppManager.shared.user.nickname!
        lblNumberPoint.text     =   String.init(format: "%d point", AppManager.shared.user.point!)
        self.tableView.dataSource = self
        self.tableView.delegate    =    self
        // Do any additional setup after loading the view.
    }

    @IBAction func buyPoint(_ sender: Any) {
        Utils.showBuyPoint(vc: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeAvatar(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose", message: "Chon cai gi do", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .destructive) { (camera) in
            self.showCamera()
        }
        let photo = UIAlertAction(title: "Photo", style: .destructive) { (photo) in
            self.showPickerImage()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (photo) in
            
        }
        alert.addAction(camera)
        alert.addAction(photo)
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
        
    }
    
    @IBAction func changeName(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Change name", message: "Please input your name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if (alertController.textFields![0]) != nil {
                // store your data
                let name = alertController.textFields![0]
                if !((name.text?.isEmpty)!){
                    let params = [
                        K_Id                    :   AppManager.shared.user.idUser as Any,
                        K_AccessToken           :   AppManager.shared.user.access_token as Any,
                        K_NickName              :   name.text as Any
                    ]
                    AppManager.shared.user_Sevice.updateWith(params: params as [String : AnyObject], completion: { (success, data) in
                        if success {
                            self.changeInfo = true
                            self.lblName.text                    =   name.text
                            AppManager.shared.user.nickname     =   name.text
                        }else{
                            
                        }
                    })
                }
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func showCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerImage.delegate = self
            pickerImage.sourceType = .camera;
            pickerImage.allowsEditing = false
            self.present(pickerImage, animated: true, completion: nil)
        }
    }
    func showPickerImage(){
        pickerImage.delegate = self
        pickerImage.allowsEditing = false
        pickerImage.sourceType = .photoLibrary
        pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(pickerImage, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var data = Data()
        /// chcek if you can return edited image that user choose it if user already edit it(crop it), return it as image
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            data = UIImagePNGRepresentation(editedImage)!
            

        } else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            data = UIImagePNGRepresentation(orginalImage)!
           
            
            /// if user update it and already got it , just return it to 'self.imgView.image'.
            
        }
        else {
            print ("error")
            
        }
        
        /// if the request successfully done just dismiss
            var image = UIImage.init(data: data)
             image = Utils.resizeImage(image: image!, targetSize: CGSize(width: 200, height: 150))
            MLIMGURUploader.uploadPhoto(UIImagePNGRepresentation(image!), title: "Update avatar", description: "", imgurClientID: IMGUR_CLIENT_ID, progress: { (progess) in
                SVProgressHUD.showProgress(progess)
            }, completionBlock: { (url) in
            let params = [
                K_Id                    :   AppManager.shared.user.idUser as Any,
                K_AccessToken           :   AppManager.shared.user.access_token as Any,
                K_Avatar                :   url as Any
                ]
                AppManager.shared.user_Sevice.updateWith(params: params as [String : AnyObject], completion: { (success, data) in
                    if success {
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        self.imgAvatar.image = image
                        AppManager.shared.user.avatar   =   url
                        self.changeInfo = true
                    }else{
                        SVProgressHUD.showError(withStatus: "Update Fail")
                    }
                    picker.dismiss(animated: true, completion: {
                        
                    })
                })
            }, failureBlock: { (reponse, err, int) in
                SVProgressHUD.showError(withStatus: "Update Fail")
                picker.dismiss(animated: true, completion: {
                    
                })
            })
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if changeInfo == true {
            let dict = AppManager.shared.user.userToDict(user: AppManager.shared.user)
            AppManager.shared.user.saveUser(dict: dict)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
enum Menucell : Int{
    case Signout
    case count
}
let identiMenuCell = "MenuCell"
extension MenuVC : UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menucell.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MenuCell = tableView.dequeueReusableCell(withIdentifier: identiMenuCell, for: indexPath) as! MenuCell
        cell.celltype = Menucell.init(rawValue: indexPath.row)
        cell.getDatatocell()
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Menucell.init(rawValue: indexPath.row) {
        case .Signout?:
            
            AppManager.shared.user  =   nil
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "currentUser")
            defaults.synchronize()
            SocketConnect.shared.socket.disconnect()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            let vc = Utils.MainStoryboard().instantiateViewController(withIdentifier: "NavigationFirstLogin") as! UINavigationController
            if let application = UIApplication.shared.delegate {
                if let window = application.window {
                    window?.rootViewController = vc
                    window?.makeKeyAndVisible()
                }
            }
            break
        default:
            break
        }
    }
    
}
