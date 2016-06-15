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

class CRStoryViewController: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storyImageView: UIImageView!
    
    @IBOutlet weak var placeholderText: UILabel!
    
    @IBOutlet weak var storyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addPic(sender: AnyObject) {
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.allowsEditing = true
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
            let photo = info[UIImagePickerControllerEditedImage] as! UIImage
            self.storyImageView.image = photo
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //todo
    }

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func publish(sender: AnyObject) {
        //todo
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
