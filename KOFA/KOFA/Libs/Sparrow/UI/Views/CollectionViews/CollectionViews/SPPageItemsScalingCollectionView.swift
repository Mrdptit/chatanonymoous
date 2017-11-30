//
//  dsa.swift
//  createBageCollectionView
//
//  Created by Ivan Vorobei on 9/6/16.
//  Copyright © 2016 Ivan Vorobei. All rights reserved.
//

import UIKit

class SPPageItemsScalingCollectionView: UICollectionView {
    
    var Layout = SPPageItemsScalingCollectionLayout()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: self.Layout)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: self.Layout)
        commonInit()
    }
}

// MARK: create
extension SPPageItemsScalingCollectionView {
    
    fileprivate func commonInit() {
        self.backgroundColor = UIColor.clear
        self.collectionViewLayout = self.Layout
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.delaysContentTouches = false
        self.isPagingEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
}


