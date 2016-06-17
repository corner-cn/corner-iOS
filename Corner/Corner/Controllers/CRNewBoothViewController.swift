//
//  CRNewBoothViewController.swift
//  Corner
//
//  Created by dliu on 6/14/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class CRNewBoothViewController: UIViewController {
    
    var location: String?

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var goodsTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet var categoryButtons: [UIButton]!
    
    let categories = ["snacks", "grocery", "handicraft"]
    
    var category: String!
    
    var newBooth: CRBooth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.category = self.categories[0]
    }
    
    @IBAction func next(sender: AnyObject) {
        newBooth = CRBooth()
        newBooth.boothOwner = nameTextField.text
        newBooth.boothName = goodsTextField.text
        newBooth.location = location
        newBooth.openTime = timeTextField.text
        newBooth.category = self.category
        self.performSegueWithIdentifier("sg_new_story", sender:newBooth)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func locate(sender: AnyObject) {
        if self.location == nil {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "正在定位.."
            if let location = g_location {
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                    if let pm = placemarks?.last {
                        print("SubThoroughfare: \(pm.subThoroughfare)")
                        print("Thoroughfare: \(pm.thoroughfare)")
                        print("AdministrativeArea: \(pm.administrativeArea)")
                        print("SubAdministrativeArea: \(pm.subAdministrativeArea)")
                        self.location = pm.thoroughfare
                        self.locationTextField.text = pm.thoroughfare
                        hud.hide(true, afterDelay: 0.5)
                    }
                })
            }
        } else {
            self.locationTextField.text = self.location
        }
    }
    
    @IBAction func chooseCategory(sender: UIButton) {
        for b in categoryButtons {
            b.setImage(UIImage(named: "radio-n"), forState: .Normal)
            let color = UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1.0)
            b.setTitleColor(color, forState: .Normal)
        }
        let selectedColor = UIColor(red: 88/255.0, green: 203/255.0, blue: 161/255.0, alpha: 1.0)
        sender.setImage(UIImage(named: "radio-y"), forState: .Normal)
        sender.setTitleColor(selectedColor, forState: .Normal)
        
        if let index = self.categoryButtons.indexOf(sender) {
            self.category = self.categories[index]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let storyController = segue.destinationViewController as! CRStoryViewController
        storyController.booth = newBooth
    }
}
