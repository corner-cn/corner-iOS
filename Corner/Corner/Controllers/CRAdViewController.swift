//
//  CRAdViewController.swift
//  Corner
//
//  Created by dliu on 6/12/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

import SDWebImage

class CRAdViewController: UIViewController {

    @IBOutlet weak var adImageView: UIImageView!
    
    @IBOutlet weak var adTitle: UILabel!
    
    var booth: CRBooth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd(booth)
    }
    
    func loadAd(booth: CRBooth?){
        if let b = booth {
            if b.images != nil && b.images?.count > 0 {
                self.adImageView.sd_setImageWithURL(NSURL(string: (b.images?.first)!), placeholderImage: UIImage(named: g_placeholer))
            }
            self.adTitle.text = b.boothName
        }
    }
    
    @IBAction func tap(sender: AnyObject) {
        if (booth?.boothId != nil) {
            self.performSegueWithIdentifier("sg_hot_detail", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! CRDetailViewController
        vc.booth = booth
    }
}
