//
//  AppToolBarVC.swift
//  KOFA
//
//  Created by may1 on 11/22/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Material
class AppToolBarVC: ToolbarController {
    fileprivate var menuButton: IconButton!
    fileprivate var switchControl: Switch!
    fileprivate var moreButton: IconButton!
    
    override func prepare() {
        super.prepare()
//        prepareMenuButton()
//        //        prepareSwitch()
//        prepareMoreButton()
//        prepareStatusBar()
//        prepareToolbar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

}
extension AppToolBarVC {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
    }
    
    fileprivate func prepareSwitch() {
        switchControl = Switch(state: .off, style: .light, size: .small)
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical)
        moreButton.addTarget(self, action: #selector(handleMoreButton), for: .touchUpInside)
    }
    
    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
        
        // Access the statusBar.
        //        statusBar.backgroundColor = Color.green.base
    }
    
    fileprivate func prepareToolbar() {
        toolbar.leftViews = [menuButton]
        toolbar.rightViews = [moreButton]
    }
}

extension AppToolBarVC {
    @objc
    fileprivate func handleMenuButton() {
//                RootNavigation?.toggleLeftView()
    }
    
    @objc
    fileprivate func handleMoreButton() {
        //        RootNavigation?.toggleRightView()
    }
}
