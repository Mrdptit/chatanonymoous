//
//  MenuCell.swift
//  KOFA
//
//  Created by may1 on 11/28/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    var celltype : Menucell!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDetail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getDatatocell(){
        switch celltype {
        case .Signout:
            lblTitle.text   =   "Sign Out"
            imgDetail.image =   UIImage.init(named: "ic_signout")
            break
            
        default:
            break
        }
    }

}
