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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(sender: AnyObject) {
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
