//
//  LocationCountyVC.swift
//  KOFA
//
//  Created by may1 on 11/25/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
let LocationCell    = "locationCell"
protocol LocationcontryDelegate {
    func selecdAt(at index: Int ,with content:String)
    
}
class LocationCountyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var location = AppManager().countries()
    var checkLocation   =   ""
    var delegate: LocationcontryDelegate?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "locationCell", bundle: nil), forCellReuseIdentifier: LocationCell)
        tableView.delegate  =   self
        tableView.dataSource =  self
        tableView.layer.borderWidth =   2.0
        tableView.layer.borderColor =   AppBaseColor.cgColor
        tableView.layer.cornerRadius    =   2.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : locationCell = tableView.dequeueReusableCell(withIdentifier: LocationCell, for: indexPath) as! locationCell
        
        
        let city : [String : AnyObject] = location.object(at: indexPath.row) as! [String : AnyObject]
        let content = city["name"]
        cell.lblContent.text    = content as? String
        if String(describing: content) == checkLocation {
            cell.imgCheck.image =   UIImage.init(named: "ic_checked")
        }else{
            cell.imgCheck.image =   UIImage.init(named: "ic_unchecked")
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city : [String : AnyObject] = location.object(at: indexPath.row) as! [String : AnyObject]
        let content = city["name"]
        
        if (delegate != nil) {
            delegate?.selecdAt(at: indexPath.row, with:content as! String)
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
}
