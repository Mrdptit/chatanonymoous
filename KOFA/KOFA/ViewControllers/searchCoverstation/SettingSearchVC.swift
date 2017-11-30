//
//  SettingSearchVC.swift
//  KOFA
//
//  Created by may1 on 11/23/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import TTRangeSlider
import FCAlertView
import Material
var changGender         =   Bool()
var changeAge           =   Bool()
var changeDistance      =   Bool()
let borderColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.5)
let backgroundColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.2)
var searchBypoint       =   Bool()
var emtypoint           =   Int()
class SettingSearchVC: UIViewController, SPSegmentControlCellStyleDelegate, SPSegmentControlDelegate, TTRangeSliderDelegate {
    
    
    @IBOutlet weak var btnClose: FABButton!
    @IBOutlet weak var sliderDistance: TTRangeSlider!
    @IBOutlet weak var sliderAge: TTRangeSlider!
    @IBOutlet weak var btnUPdate: FABButton!
    var selectGender        =   Int()
    var selectAgeMin        =   0
    var selectAgeMax        =   100
    var selectDistanceMin   =   0
    var selectDistanceMax   =   100
    @IBOutlet weak var segmentAge: SPSegmentedControl!
    
    let debouncer = Debouncer(interval: 1)
    
    var timerClose: Timer!
    var timer: Timer!
    var countEmit = 0
    
    var showTextView:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegment()
        setupSlider()
        self.navigationController?.navigationBar.backgroundColor    =   .clear
        
        SocketConnect.shared.addHandleSearchings { (status, data) in
            if(status == false){
                if(self.countEmit == 8){
                    if(self.timer != nil){
                        
                        self.timer.invalidate()
                        self.dismiss(animated: true, completion: {
                        })
                    }
                }
            } else {
                if(self.timerClose != nil){
                    self.countEmit = 5
                    self.timerClose.invalidate()
                }
                if(self.timer != nil){
                    self.timer.invalidate()
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        // Do any additional setup after loading the view.
    }
    private func setupSlider(){
        self.sliderAge.layer.borderColor            =   borderColor.cgColor
        self.sliderAge.layer.cornerRadius           =   self.sliderAge.frame.height*0.5
        self.sliderAge.layer.backgroundColor        =   UIColor.white.cgColor
        self.sliderAge.delegate                     =   self
        self.sliderDistance.layer.cornerRadius      =   self.sliderDistance.frame.height*0.5
        self.sliderDistance.layer.backgroundColor   =   UIColor.white.cgColor
        self.sliderDistance.layer.borderColor       =   borderColor.cgColor
        self.sliderDistance.delegate                =   self
        self.btnUPdate.layer.backgroundColor        =   UIColor.white.cgColor
        self.btnUPdate.layer.borderColor            =   borderColor.cgColor
        self.btnUPdate.layer.borderWidth            =   2.0
        self.btnUPdate.layer.cornerRadius           =   self.btnUPdate.frame.height*0.5
        
        self.btnClose.layer.backgroundColor         =   backgroundColor.cgColor
        self.btnClose.setBackgroundImage(Icon.cm.close, for: .normal)
        
        self.btnClose.tintColor                     =   UIColor.white
    }
    private func setupSegment(){
        segmentAge.layer.borderColor    =   borderColor.cgColor
        segmentAge.backgroundColor      =   backgroundColor
        segmentAge.styleDelegate        =   self
        segmentAge.delegate             =   self
        
        //segment
        let xFirstCell = self.createCell(
            text: NSLocalizedString("srt_all", comment: ""),
            image: self.createImage(withName: "ic_gender")
        )
        let xSecondCell = self.createCell(
            text: NSLocalizedString("srt_male", comment: ""),
            image: self.createImage(withName: "ic_male")
        )
        let xThirdCell = self.createCell(
            text: NSLocalizedString("srt_female", comment: ""),
            image: self.createImage(withName: "ic_female")
        )
        for cell in [xFirstCell, xSecondCell, xThirdCell] {
            cell.Layout = .textWithImage
            self.segmentAge.add(cell: cell)
        }
    }
    private func createCell(text: String, image: UIImage) -> SPSegmentedControlCell {
        let cell = SPSegmentedControlCell.init()
        cell.label.text = text
        cell.label.font = UIFont(name: "Roboto-Medium", size: 13.0)!
        cell.imageView.image = image
        return cell
    }
    private func createImage(withName name: String) -> UIImage {
        return UIImage.init(named: name)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    // MARK: - SegmentDelegate
    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.black
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.black
        }, completion: nil)
        changGender = true
        selectGender    = index
    }
    
    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.white
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.white
        }, completion: nil)
    }
    
    func indicatorViewRelativPosition(position: CGFloat, onSegmentControl segmentControl: SPSegmentedControl) {
        let percentPosition = position / (segmentControl.frame.width - position) / CGFloat(segmentControl.cells.count - 1) * 100
        let intPercentPosition = Int(percentPosition)
//        self.percentIndicatorViewLabel.text = "scrolling: \(intPercentPosition)%"
    }
    //MARK: SlidetDelegate
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        
        if sender == sliderAge {
            changeAge       = true
            selectAgeMax    = Int(selectedMaximum)
            selectAgeMin    = Int(selectedMinimum)
            print("Min Age: \(selectedMinimum)\nMax Age: \(selectedMaximum)")
        }else if sender == sliderDistance {
            changeDistance       = true
            selectDistanceMax    = Int(selectedMaximum)
            selectDistanceMin    = Int(selectedMinimum)
            print("Min Distance: \(selectedMinimum)\nMax Distance: \(selectedMaximum)")
        }
    }
    func didStartTouches(in sender: TTRangeSlider!) {
        print("Start")
    }
    // MARK: - Action Button
    @IBAction func actUpdate(_ sender: UIButton) {
        if checkPoint() > 0 {
            let alert = FCAlertView()
            alert.tintColor =   AppBaseColor
            
            let content1 = NSString(format: NSLocalizedString("srt_purche", comment: "") as NSString, Utils.checkGenner(value: selectGender),selectAgeMin,selectAgeMax,selectDistanceMin,selectDistanceMax,checkPoint())
            
            alert.addButton(NSLocalizedString("srt_OK", comment: ""), withActionBlock: {
                if self.checkPoint() < AppManager.shared.user.point!{
                    searchBypoint = true
                    emtypoint = self.checkPoint()
                    self.showAnimation()
                }else{
                    let alert = FCAlertView()
                    alert.addButton("Buy Now", withActionBlock: {
                        Utils.showBuyPoint(vc: self)
                    })
                    alert.showAlert(withTitle: "Error", withSubtitle: "Your coin number is not enough to make please purchase more coin to continue", withCustomImage: UIImage.init(named: ""), withDoneButtonTitle: "Ok", andButtons: nil)
                }
            })
            alert.addButton("Search Default", withActionBlock: {
                self.showAnimation()
            })
            alert.showAlert(withTitle: "Search Tranger", withSubtitle: String(content1), withCustomImage: UIImage.init(named: "ic_money"), withDoneButtonTitle: "Cancel", andButtons: nil)
        }else{
            showAnimation()
            SocketConnect.shared.emit(on: "searchings", any: [[K_Id:AppManager.shared.user.idUser!]])
            print("----------------------------- EMIT \(self.countEmit)")
        }
      
//        self.dismiss(animated: true) {
//
//        }
    }
    func showAnimation(){
        let viewadd = UIView()
        self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(emitSearching), userInfo: nil, repeats: true)
        self.timerClose = Timer.scheduledTimer(timeInterval: 12.0, target: self, selector: #selector(dissmitview), userInfo: nil, repeats: false)
        viewadd.frame = self.view.bounds
        viewadd.backgroundColor = .white
        viewadd.addSubview(Utils.animationLoading(view: self.view))
        
        
        self.showTextView = UILabel(frame: CGRect(x: viewadd.frame.origin.x, y: viewadd.frame.origin.y, width: viewadd.frame.size.width, height: viewadd.frame.size.height/3))
        self.showTextView.text = "Gender: \(Utils.checkGenner(value: selectGender)) \nAge: \(selectAgeMin) - \(selectAgeMax) \nDistance: \(selectDistanceMin) - \(selectDistanceMax)"
        self.showTextView.textAlignment = .center
        self.showTextView.font = RobotoFont.regular(with: 21)
        self.showTextView.numberOfLines = 0
        self.showTextView.textColor = AppBaseColor
        viewadd.addSubview(self.showTextView)
        
        self.view.addSubview(viewadd)
    }
    @objc func emitSearching(){
        self.countEmit += 1
        if(self.countEmit == 2){
            UIView.animate(withDuration: 0.2, animations: {
                self.showTextView.text = "Searching..."
            });
        }
        SocketConnect.shared.emit(on: "searchings", any: [[K_Id:AppManager.shared.user.idUser!]])
        print("----------------------------- EMIT \(self.countEmit)")
    }
    
    private func checkPoint() -> Int{
        var point = 0
        if changGender && selectGender != 0 {
            point += 3
        }
        if changeAge && (selectAgeMin != 0 || selectAgeMax != 100){
            point += 3
        }
        if changeDistance && (selectDistanceMax != 100 || selectDistanceMin != 0){
            point += 3
        }
        return point
    }
    
    @objc
    func dissmitview(){
        self.dismiss(animated: true) {
            
            FCAlertView().showAlert(withTitle: "User not found", withSubtitle: "No user found, and you will not be deducted coin", withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
            
            self.timerClose.invalidate()
        }
    }
    @IBAction func btnClose(_ sender: FABButton) {
        self.dismiss(animated: true) {
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor    =   AppBaseColor
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
