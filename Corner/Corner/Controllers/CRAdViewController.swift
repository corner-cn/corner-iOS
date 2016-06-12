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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAd()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAd() -> Void {
        let imageURL = NSURL.init(string: "http://i1.hexunimg.cn/2013-09-08/157829171.jpg")
        self.adImageView.sd_setImageWithURL(imageURL)
        self.adTitle.text = "AppAnnie@sanlitun"
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
