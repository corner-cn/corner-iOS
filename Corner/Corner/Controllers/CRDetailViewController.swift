//
//  CRDetailViewController.swift
//  Corner
//
//  Created by dliu on 6/14/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class CRDetailViewController: UIViewController {
    
    var boothID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
