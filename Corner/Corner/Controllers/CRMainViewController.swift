//
//  CRMainViewController.swift
//  Corner
//
//  Created by dliu on 6/12/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

class CRMainViewController: UITableViewController {

    let r_CRCategoryCell: String = "r_CRCategoryCell"
    let r_CRHelpCell: String = "r_CRHelpCell"
    
    var images : [String] = []
    var titles : [String] = []
    
    var cityButton : CRExchangeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        
        let nib = UINib.init(nibName: "CRCategoryCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: r_CRCategoryCell)
        let helpCellNib = UINib.init(nibName: "CRHelpCell", bundle: nil)
        self.tableView.registerNib(helpCellNib, forCellReuseIdentifier: r_CRHelpCell)
        let url = "http://cdn.images.express.co.uk/img/dynamic/11/590x/Food-health-603127.jpg"
        images = [url, url, url, url]
        titles = ["附近","小吃","杂货","手艺"]
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
        
        //MARK:
        let titleView = UIImageView(image: UIImage(named: "title"))
        self.navigationItem.titleView = titleView
        
        cityButton = CRExchangeButton(type: .Custom)
        cityButton.setImage(UIImage(named: "indicator"), forState: .Normal)
        cityButton.setImage(UIImage(named: "indicator"), forState: .Highlighted)
        cityButton.setTitle("北京", forState: .Normal)
        cityButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        cityButton.layoutIfNeeded()
        cityButton.sizeToFit()

        cityButton.addTarget(self, action: #selector(changeCity), forControlEvents:.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cityButton)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(updateCity(_:)), name: nt_ChangeCity, object: nil)
    }

//    // MARK: - Table view data source
//
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: update
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let categoryCell = tableView.dequeueReusableCellWithIdentifier(r_CRCategoryCell, forIndexPath: indexPath) as! CRCategoryCell
            categoryCell.updateContent(images, titleNames: titles)
            return categoryCell
        } else {
            let helpCell = tableView.dequeueReusableCellWithIdentifier(r_CRHelpCell, forIndexPath: indexPath) as! CRHelpCell
            helpCell.updateContent()
            return helpCell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let v = NSBundle.mainBundle().loadNibNamed("CRMainTableSectionHeader", owner: nil, options: nil).first as! UIView
            return v
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 44.0
    }
 

//  MARK: - Selector & Actions
    
    func changeCity() {
        self.performSegueWithIdentifier("sg_change_city", sender: self)
    }
    
    func updateCity(notification: NSNotification) {
        cityButton.setTitle(g_city, forState:.Normal)
        self.performSelector(#selector(loadData), withObject: nil, afterDelay: 2.0)
    }
    
    func loadData() {
        self.refreshControl?.beginRefreshing()
        //todo load data asynchrously
    }
}
