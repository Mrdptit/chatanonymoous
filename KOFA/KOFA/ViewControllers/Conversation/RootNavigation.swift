//
//  RootNavigation.swift
//  KOFA
//
//  Created by may1 on 11/16/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Material
class RootNavigation: UINavigationController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = AppBaseColor
        self.navigationController?.navigationBar.backIndicatorImage = Icon.cm.arrowBack
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = Icon.cm.arrowBack
        self.navigationController?.navigationBar.backItem?.title    =   ""
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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

