//
//  CRDetailViewController.swift
//  Corner
//
//  Created by dliu on 6/14/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class CRDetailViewController: UIViewController {
    
    var booth: CRBooth?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var helpLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var storyTitleLabel: UILabel!
    
    @IBOutlet weak var storyLabel: UILabel!
    
    var iamgeViewController: CRImageController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI(self.booth)
        self.loadBoothDetail(boothId: booth?.boothId!)
    }
        
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func checkin(sender: AnyObject) {
        let button = sender as! UIButton
        button.enabled = false
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "签到成功"
        hud.customView = UIImageView(image: UIImage(named: "like"))
        hud.mode = .CustomView
        hud.hide(true, afterDelay: 1.5)
    }
    
    @IBAction func share(sender: AnyObject) {
        if self.booth != nil && self.booth?.thumnail != nil {
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(NSURL(string: (booth?.thumnail!)!), options:SDWebImageDownloaderOptions(), progress: nil) {
                image, data, error, r in
                let url = NSURL(string: "http://ijiejiao.cn")
                dispatch_async(dispatch_get_main_queue(), {
                    let shareViewController = UIActivityViewController(activityItems:[(self.booth?.boothName)!, image, url!], applicationActivities: nil)
                    self.presentViewController(shareViewController, animated: true, completion: nil)
                    shareViewController.completionWithItemsHandler = {(activetype: String?, r:Bool,items:[AnyObject]?, error: NSError?) -> Void in
                        shareViewController.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            }
        } else {
            let url = NSURL(string: "http://ijiejiao.cn")
            dispatch_async(dispatch_get_main_queue(), {
                let shareViewController = UIActivityViewController(activityItems:[(self.booth?.boothName)!, UIImage(named:g_placeholer)!, url!], applicationActivities: nil)
                self.presentViewController(shareViewController, animated: true, completion: nil)
                shareViewController.completionWithItemsHandler = {(activetype: String?, r:Bool,items:[AnyObject]?, error: NSError?) -> Void in
                    shareViewController.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
    func loadBoothDetail(boothId id: String?) {
        if id != nil {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "加载摊铺信息..."
            Service.boothDetail(boothId: id!) {
                booth in
                hud.hide(true)
                self.booth = booth
                self.updateUI(self.booth)
                self.iamgeViewController.booth = booth
                self.iamgeViewController.loadad()
            }
        }
    }
    
    func updateUI(booth: CRBooth?) {
        if booth != nil {
            self.titleLabel.text = booth?.boothName
            self.helpLabel.text = booth?.likeStr
            self.locationLabel.text = booth?.location
            self.timeLabel.text = booth?.openTime
            self.storyTitleLabel.text = booth?.boothOwner
            self.storyLabel.text = booth?.boothStory
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sg_iamge" {
            iamgeViewController = segue.destinationViewController as! CRImageController
        } else if segue.identifier == "sg_map" {
            let mapViewController = segue.destinationViewController as! CRMapViewController
            mapViewController.booth = booth
        }
    }
}
