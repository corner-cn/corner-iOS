//
//  CRStoryViewController.swift
//  Corner
//
//  Created by dliu on 6/15/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices

import MBProgressHUD
import SDWebImage

class CRStoryViewController: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var iamgeCollectionViewHeightLayout: NSLayoutConstraint!
    
    @IBOutlet weak var placeholderText: UILabel!
    
    @IBOutlet weak var storyTextView: UITextView!
    
    var booth: CRBooth!
    
    lazy var images: [UIImage] = [UIImage(named: "add_pic")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCollectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.storyTextView.becomeFirstResponder()
    }
    
    func addPic() {
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.allowsEditing = false
        pc.sourceType = .Camera
        pc.mediaTypes = [kUTTypeImage as String]
        self.presentViewController(pc, animated: true, completion: {
            //todo
        })
    }
    
    func textViewDidChange(textView: UITextView) {
        //todo
        self.placeholderText.hidden = textView.hasText()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.placeholderText.hidden = textView.hasText()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType]
        if mediaType as! String == kUTTypeImage as String {
            let photo = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.images.insert(photo, atIndex: 0)
            self.imageCollectionView.reloadData()
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func publish(sender: AnyObject) {
        self.view.endEditing(true)
        booth.boothStory = storyTextView.text
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在提交..."
        Service.newBooth(booth) {
            newBooth in
            print("new booth\(newBooth?.boothId)")
            Service.uploadBoothImages(self.images, boothId:(newBooth?.boothId)!, completion: {r in
                //todo
                hud.labelText = "提交成功"
                hud.hide(true, afterDelay: 1.0)
                let delay = dispatch_time(DISPATCH_TIME_NOW, 1 * 1000000000)
                dispatch_after(delay, dispatch_get_main_queue(), {
                    hud.hide(true)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
            })
        }
    }

//  MAKR: UICollectionViewDelegate & UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.imageCollectionView.dequeueReusableCellWithReuseIdentifier("r_imageCell", forIndexPath: indexPath) as! CRImageCollectionCell
        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if indexPath.row == self.images.count - 1 {
            self.addPic()
        } else {
            //todo
        }
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

class CRImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}




