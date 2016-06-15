//
//  CRCityViewController.swift
//  Corner
//
//  Created by dliu on 6/14/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

class CRCityViewController: UITableViewController {
    
    let reuseIdentifier = "r_CityCell"
    
    var cities = ["北京", "上海",  "广州", "深圳", "成都", "重庆", "天津", "其他"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }

    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CRCityCell
        cell.cityLabel.text = cities[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        g_city = cities[indexPath.row]
        NSNotificationCenter.defaultCenter().postNotificationName(nt_ChangeCity, object:nil)
        self.cancel(self)
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

class CRCityCell : UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    
}
