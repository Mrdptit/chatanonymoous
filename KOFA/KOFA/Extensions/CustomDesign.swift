//
//  UITextField+CustomDesign.swift
//  KOFA
//
//  Created by may10 on 11/17/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let slide = controller as? SlideMenuController{
            if let main = slide.mainViewController {
                return topViewController(controller: main)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension Notification.Name {
    static let searchings = Notification.Name("searchings")
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIButton {
    func roundCorners(corners:UIRectCorner, radius: CGFloat, withColor: UIColor, andTextColor: UIColor)
    {
        self.layer.masksToBounds = true
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = rectShape.path
        borderLayer.fillColor = withColor.cgColor
        borderLayer.frame = self.bounds
        borderLayer.strokeColor = AppBaseColor.cgColor
        borderLayer.lineWidth = 4.0
        self.layer.addSublayer(borderLayer)
        
        let title = self.titleLabel
        title?.textColor = andTextColor
        self.addSubview(title!)
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func configTextfield(){
        self.layer.borderColor = AppBaseColor.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = self.frame.size.height/2
    }
}
extension UILabel {
    func configLabel(){
        self.layer.borderColor = AppBaseColor.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = self.frame.size.height/2
    }
}
