    //
//  ImappPurchase.swift
//  KOFA
//
//  Created by may1 on 11/28/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import RMStore
class ImappPurchase: NSObject {
    let pruoduct : NSSet    = []
    let store : RMStore = RMStore()
    func setup(vc: UIViewController){
        store.add(vc as! RMStoreObserver)
    }
}
