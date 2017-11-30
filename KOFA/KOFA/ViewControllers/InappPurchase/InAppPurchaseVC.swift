//
//  InAppPurchaseVC.swift
//  KOFA
//
//  Created by may1 on 11/28/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import RMStore
import FCAlertView
import Material
import SVProgressHUD
let identifile = "InAppPurchaseCell"
enum inapp : Int {
    case buy1dola
    case buy3dola
    case buy5dola
    case counter
}
class InAppPurchaseVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,InAppPurchaseCellDelegate {
    @IBOutlet weak var btnClose: FABButton!
    let store = RMStore()
    
    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnClose.setBackgroundImage(Icon.cm.close, for: .normal)
        btnClose.layer.backgroundColor  =   backgroundColor.cgColor
        UIApplication.shared.isNetworkActivityIndicatorVisible  = true
        store.requestProducts(Set(IDinApp), success: { (product, invaliproduct) in
            UIApplication.shared.isNetworkActivityIndicatorVisible  = false
        }) { (error) in
            FCAlertView().showAlert(withTitle: "Error", withSubtitle: error?.localizedDescription, withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inapp.counter.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : InAppPurchaseCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifile, for: indexPath) as! InAppPurchaseCell
        cell.title = indexPath.row
        cell.getdatatoCell()
        cell.delegate = self
        return cell
    }
    func tapIn(index: Int) {
        if !RMStore.canMakePayments(){
            return
        }
        let ID : String = IDinApp[index]
        UIApplication.shared.isNetworkActivityIndicatorVisible  =   true
        store.addPayment(ID, success: { (transaction) in
            UIApplication.shared.isNetworkActivityIndicatorVisible  =   false
            var point = AppManager.shared.user.point ?? 0
            switch index {
            case 0:
                
                point += 10
                AppManager.shared.user.point = point
                break
            case 1:
                point += 40
                AppManager.shared.user.point = point
                break
            case 2:
                point += 100
                AppManager.shared.user.point = point
                break
            default:
                break
            }
            let params : [String:AnyObject] = [
                K_UsersID           :   AppManager.shared.user.idUser as AnyObject,
                K_AccessToken       :   AppManager.shared.user.access_token as AnyObject,
                K_Point             :   AppManager.shared.user.point as AnyObject
                
            ]
            UserSevice().updateWith(params: params, completion: { (success, data) in
                if success{
                    SVProgressHUD.showSuccess(withStatus: "Success")
                }
            })
        }) { (transaction, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible  =   false
            FCAlertView().showAlert(withTitle: "Error", withSubtitle: error?.localizedDescription, withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-30) / 2.0, height: (collectionView.frame.height/2-20))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 5, -10, 5)
    }
    
    
}
