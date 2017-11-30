//
//  ListImage.swift
//  KOFA
//
//  Created by may1 on 11/20/17.
//  Copyright © 2017 smartconnect. All rights reserved.
//

import UIKit
import Photos
import Material
import MobileCoreServices
protocol listImageDelegate{
    func tapImage(at collectionview: UICollectionView, index: Int, withData image: Data)
}
class ListImage: UIView,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var images = NSMutableArray()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMore: UIButton!
    var delegate: listImageDelegate?
    var listPhotos = [PHAsset]()
    var clickMore : (() -> Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        getPhotos()
        btnMore.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btnMore.layer.cornerRadius  =   btnMore.frame.height*0.5
        collectionView.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(tap)
        
    }
    @objc func onTapImage(sender: UITapGestureRecognizer){
        print("heheee")
        if (sender.state == .ended) {
            let location = sender.location(in: self.collectionView)
            let indexPath = self.collectionView.indexPathForItem(at: location) ?? nil
            if (delegate != nil && indexPath != nil) {
                let photo = self.listPhotos[(indexPath?.row)!]
                readImageWith(photo: photo) { (data) in
                    self.delegate?.tapImage(at: self.collectionView, index: (indexPath?.row)!, withData: data)
                }
            }
        }
    }
    
    
    @IBAction func btnMore(_ sender: Any) {
        clickMore()
    }
    func getPhotos()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                self.listPhotos = []
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                let lists = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                if lists.count > 0 {
                    for i in 0 ... lists.count - 1 {
                        self.listPhotos.append(lists[i])
                    }
                }
                print("Found \(self.listPhotos.count) images")
                break
            case .denied, .restricted:
                print("Not allowed")
                self.collectionView?.isHidden = true
                break
                
            case .notDetermined:
                print("Not determined yet")
                self.collectionView?.isHidden = true
                break
            }
        }
        
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
//MARK: - CollectionView
extension ListImage{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPhotos.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.height, height: self.collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 1, 1, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let photo = self.listPhotos[indexPath.row]
        readImageWith(photo: photo) { (data) in
            let image = UIImage.init(data: data)
            if (image != nil) {
                cell.img.image = image
            }
        }
        return cell
    }
    @objc func ImageTapped(button: UIButton){
        print(button.tag)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func readImageWith(photo : PHAsset!, completion: @escaping (_ result: Data)->()){
        let options = PHImageRequestOptions()
        PHImageManager.default().requestImageData(for: photo, options: options, resultHandler: { (data, repont, img, info) in
            completion(data!)
            
        })
    }
}
