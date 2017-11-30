//
//  CardInfo.swift
//  KOFA
//
//  Created by may1 on 11/23/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Material

class CardInfo: UITableViewCell {

    @IBOutlet weak var card: Card!
    
    fileprivate var toolbar: Toolbar!
    var moreButton: IconButton!
    fileprivate var contentView1: UILabel!
    fileprivate var imageavatar       : UIImage!
    fileprivate var bottomBar: Bar!
    fileprivate var dateFormatter: DateFormatter!
    var dateLabel: UILabel!
    fileprivate var favoriteButton: IconButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        card.backgroundColor = Color.grey.lighten5
        
        prepareDateFormatter()
        prepareDateLabel()
        prepareFavoriteButton()
        prepareMoreButton()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        prepareCard()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    fileprivate func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    fileprivate func prepareDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.grey.base
        dateLabel.text = dateFormatter.string(from: Date.distantFuture)
    }
    
    fileprivate func prepareFavoriteButton() {
        let randomIndex     =   Int(arc4random_uniform(UInt32(arr_avatar.count)))
        var img = UIImage.init(named: arr_avatar[randomIndex])
        img = Utils.resizeImage(image: img!, targetSize:CGSize.init(width: 25, height: 25))
        favoriteButton = IconButton(image:img, tintColor: Color.red.base)
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.grey.base)
    }
    
    fileprivate func prepareToolbar() {
        toolbar = Toolbar(rightViews: [moreButton])
        toolbar.backgroundColor =   Color.grey.lighten5
        //toolbar.title = AppManager.shared.user.nickname
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Ha Noi - Hai phong"
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.grey.base
    }
    
    fileprivate func prepareContentView() {
        contentView1 = UILabel()
        contentView1.numberOfLines = 0
        contentView1.text = "Material is an animation and graphics framework that is used to create beautiful applications."
        contentView1.font = RobotoFont.regular(with: 14)
    }
    
    fileprivate func prepareBottomBar() {
        bottomBar = Bar()
        bottomBar.backgroundColor   =   Color.grey.lighten5
        bottomBar.leftViews = [favoriteButton]
        bottomBar.rightViews = [dateLabel]
    }
    fileprivate func prepareCard() {
//        card = Card()
        
        card.toolbar = toolbar
        card.toolbarEdgeInsetsPreset = .square3
        card.toolbarEdgeInsets.bottom = 0
        card.toolbarEdgeInsets.right = 8
        
//        card.contentView = contentView1
//        card.contentViewEdgeInsetsPreset = .wideRectangle3
        
        card.bottomBar = bottomBar
        card.bottomBarEdgeInsetsPreset = .wideRectangle2
        
        
    }
    
}
