//
//  Utils.swift
//  KOFA
//
//  Created by may1 on 11/15/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Material
import RNNotificationView
open class Utils: NSObject {
    
        
        
    
    static func checkGenner(value : Int) -> String{
        switch value {
        case 0:
            return "Unknown"
        case 1:
            return "Male"
        case 2:
            return "Female"
        default:
            return "Unknown"
        }
    }
    static func birthdayToAge(value : String) -> Int{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        let birthday = dateFormat.date(from: value)
        let date = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        let birthdayYear = calendar.component(.year, from: birthday ?? date)
        return currentYear - birthdayYear
    }
    open static func UploadImage(image: UIImage, for username: String) {
        
        let imageData = UIImagePNGRepresentation(image)
        let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        let url = "https://api.imgur.com/3/upload"
        
        let parameters = [
            "image": base64Image
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 1) {
                multipartFormData.append(imageData, withName: username, fileName: "\(username).png", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value?.data(using: .utf8))!, withName: key)
            }}, to: url, method: .post, headers: ["Authorization": "Client-ID " + IMGUR_CLIENT_ID],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.response { response in
                            //This is what you have been missing
                            print(response)
                            let json1 = JSON(response.data!)
                            print (json1 as Any)
//                            let json = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any]
//                            print(json as Any)
//                            let imageDic = json?["data"] as? [String:Any]
//                            print(imageDic?["link"] as Any)
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
        })
        
    }
    static func timeAgoFromNow(time: Double) -> String {
        let numericDates = true
        let date = NSDate(timeIntervalSince1970: time/1000)
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    static func animationLoading(view : UIView) -> UIImageView {
        let button = UIImageView()
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.center = view.center;
        
        let  c = UIView.init(frame: button.bounds)
        c.backgroundColor = AppBaseColor;
        c.layer.cornerRadius = 40;
        let img = UIImageView.init(image: UIImage.init(named: "btn-searching"))
        img.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        img.layer.cornerRadius = 20;
        img.center = c.center;
        img.contentMode = .scaleAspectFit;
        c.addSubview(img)
        button.addSubview(c)
        button.sendSubview(toBack: c)
        
        
        let f = UIView.init(frame: button.bounds)
        f.backgroundColor = AppBaseColor.withAlphaComponent(0.5)
        f.layer.cornerRadius = 40;
        button.addSubview(f)
        button.sendSubview(toBack: f)
        
        let pulseAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        pulseAnimation.duration = 0.75
        ;
        pulseAnimation.toValue = 1.1
        pulseAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true;
        pulseAnimation.repeatCount = MAXFLOAT;
        c.layer.add(pulseAnimation, forKey: "a")
        
        let fade = CABasicAnimation.init(keyPath: "opacity")
        fade.toValue = 0;
        let pulse = CABasicAnimation.init(keyPath: "transform.scale")
        pulse.toValue = 3;
        let group = CAAnimationGroup()
        //  [CAAnimationGroup animation];
        group.animations = [fade,pulse];
        group.duration = 1.65;
        group.repeatCount = MAXFLOAT;
        f.layer.add(group, forKey: "g")
        //    [f.layer addAnimation:group forKey:@"g"];
        return button;
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize =   CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            newSize =   CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    // Storyboard
    static func MainStoryboard() -> UIStoryboard {
        let srb = UIStoryboard.init(name: "Main", bundle: nil)
        return srb
    }
    static func InAppStoryboard() -> UIStoryboard {
        let srb = UIStoryboard.init(name: "InApp", bundle: nil)
        return srb
    }
    static func showBuyPoint(vc : UIViewController){
        let v : InAppPurchaseVC! = self.InAppStoryboard().instantiateViewController(withIdentifier: "InAppPurchaseVC") as! InAppPurchaseVC
        vc.present(v, animated: true) {
            
        }
    }
    static func showProfileView(vc : UIViewController) {
        let vctest : ProfileVC! = self.MainStoryboard().instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vctest.modalPresentationStyle = .overCurrentContext
        vctest.motionTransitionType     =   .zoom
        vctest.user =   AppManager.shared.user
        vc.present(vctest, animated: true)
        
    }
    static func showProfile(forUser user: User, from viewcontroller:UIViewController) {
        let vc : ProfileVC! = self.MainStoryboard().instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//        vc.motionp = .overCurrentContext
        vc.motionTransitionType     =   .zoom
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overCurrentContext
        vc.user =   user
        viewcontroller.present(vc, animated: true)
        
    }
    static func checkStatus (type: Int) -> String{
        switch type {
        case 0:
            return "Sent"
        case 1:
            return "Reciver"
        case 2:
            return "Seen"
        default:
            return "Loading"
        }
        
    }
}
extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}
extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
