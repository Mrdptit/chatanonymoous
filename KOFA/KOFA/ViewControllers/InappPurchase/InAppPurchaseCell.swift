//
//  InAppPurchaseCell.swift
//  KOFA
//
//  Created by may1 on 11/28/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Material
protocol InAppPurchaseCellDelegate {
    func tapIn(index : Int)
}
class InAppPurchaseCell: UICollectionViewCell {
    var delegate : InAppPurchaseCellDelegate!
    var title : Int! = 0
    @IBOutlet weak var content: ImageCard!
    /// Conent area.
    fileprivate var imageView: UIImageView!
    fileprivate var contentTitle: UILabel!
    
    /// Bottom Bar views.
    fileprivate var bottomBar: Bar!
    fileprivate var dateFormatter: DateFormatter!
    fileprivate var dateLabel: UILabel!
    fileprivate var favoriteButton: RaisedButton!
    fileprivate var shareButton: IconButton!
    
    /// Toolbar views.
    fileprivate var toolbar: Toolbar!
    fileprivate var moreButton: IconButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    func getdatatoCell() {
        setupUI()
    }
    func setupUI(){
        prepareImageView()
        prepareDateFormatter()
        prepareDateLabel()
        prepareFavoriteButton()
        prepareShareButton()
        prepareMoreButton()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        preparePresenterCard()

    }
    
}
extension InAppPurchaseCell {
    fileprivate func prepareImageView() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "Icon_coin")?.resize(toWidth: content.frame.width)
    }
    
    fileprivate func prepareDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    fileprivate func prepareDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .center
        dateLabel.text = dateFormatter.string(from: Date.distantFuture)
    }
    
    fileprivate func prepareFavoriteButton() {
        favoriteButton = RaisedButton(title: returnTitle(index: title), titleColor: AppBaseColor)
        favoriteButton.addTarget(self, action: #selector(tapBuyInapp), for: .touchUpInside)
    }
    @objc func tapBuyInapp(){
        if (delegate != nil){
            delegate.tapIn(index: title)
        }
    }
    fileprivate func prepareShareButton() {
        shareButton = IconButton(image: Icon.cm.share, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.blueGrey.base)
    }
    
    fileprivate func prepareToolbar() {
        toolbar = Toolbar(rightViews: nil)
        toolbar.layer.backgroundColor   =   UIColor.black.withAlphaComponent(0.25).cgColor
        toolbar.title = returnPointNumber(index: title)
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
        
        toolbar.detail = "Coin"
        toolbar.detailLabel.font    =   RobotoFont.medium(with: 15)
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
    }
    
    fileprivate func prepareContentView() {
        contentTitle = UILabel()
        contentTitle.numberOfLines = 0
        contentTitle.text = ""
        contentTitle.font = RobotoFont.regular(with: 14)
    }
    
    fileprivate func prepareBottomBar() {
        bottomBar = Bar(leftViews: nil, rightViews: nil, centerViews: [favoriteButton])
    }
    
    fileprivate func preparePresenterCard() {
        
        
        content.toolbar = toolbar
        content.toolbarEdgeInsetsPreset = .square3
        
        content.imageView = imageView
        content.layer.borderColor = AppBaseColor.cgColor
        content.layer.borderWidth   =   2.0
        content.contentView = contentTitle
        content.contentViewEdgeInsetsPreset = .square3
        
        content.bottomBar = bottomBar
        content.bottomBarEdgeInsetsPreset = .wideRectangle2
    }
    fileprivate func returnTitle(index: Int) -> String{
        switch index {
        case 0:
            return "Buy 1$"
        case 1:
            return "Buy 3$"
        case 2:
            return "Buy 5$"
        default:
            return ""
        }
    }
    
    fileprivate func returnPointNumber(index: Int) -> String{
        switch index {
        case 0:
            return "10"
        case 1:
            return "40"
        case 2:
            return "100"
        default:
            return ""
        }
    }
}
