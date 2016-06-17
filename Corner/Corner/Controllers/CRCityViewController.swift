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
        
        let cellNib = UINib(nibName: "CRSimpleCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: reuseIdentifier)
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CRSimpleCell
        cell.crLabel.text = cities[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        g_city = cities[indexPath.row]
        NSNotificationCenter.defaultCenter().postNotificationName(nt_ChangeCity, object:nil)
        self.cancel(self)
    }
}