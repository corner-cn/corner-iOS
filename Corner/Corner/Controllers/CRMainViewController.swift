//
//  CRMainViewController.swift
//  Corner
//
//  Created by dliu on 6/12/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit
import SDWebImage

class CRMainViewController: UITableViewController {

    let r_CRHelpCell: String = "r_CRHelpCell"
    
    @IBOutlet var categoryButtons: [CRDesignableButton]!
    
    var categoryIndex: Int! = 0
    
    var titles: [String] = []
    
    var booths: [CRBooth]? = []
    
    var cityButton: CRExchangeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
        
        let helpCellNib = UINib.init(nibName: "CRHelpCell", bundle: nil)
        self.tableView.registerNib(helpCellNib, forCellReuseIdentifier: r_CRHelpCell)
        
        titles = ["附近","小吃","杂货","手艺"]
        for i in 0...titles.count - 1 {
            let button = categoryButtons[i]
            let title = titles[i]
            button.setTitle(title, forState: .Normal)
        }
        
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
        
        self.refresh()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if let refreshing = self.refreshControl?.refreshing {
            if refreshing {
                self.refreshControl?.endRefreshing()
            }
        }
    }

//    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let c = booths?.count {
            return c
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(r_CRHelpCell, forIndexPath: indexPath) as! CRHelpCell
        cell.updateContent(booths?[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       return NSBundle.mainBundle().loadNibNamed("CRMainTableSectionHeader", owner: nil, options: nil).first as? UIView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let booth = self.booths![indexPath.row]
        self.performSegueWithIdentifier("sg_main_detail", sender:booth)
    }
 

//  MARK: - Selector & Actions
    
    @IBAction func toCategoryPage(sender: CRDesignableButton) {
        if let index = categoryButtons.indexOf(sender) {
            categoryIndex = index
            self.performSegueWithIdentifier("sg_category", sender: self)
        }
    }
    
    func changeCity() {
        self.performSegueWithIdentifier("sg_change_city", sender: self)
    }
    
    func updateCity(notification: NSNotification) {
        cityButton.setTitle(g_city, forState:.Normal)
        self.refresh()
    }
    
    func refresh() {
        self.tableView.setContentOffset(CGPointMake(0, -(self.refreshControl?.frame.height)!), animated: true)
        self.refreshControl?.beginRefreshing()
        self.refreshControl?.sendActionsForControlEvents(.ValueChanged)
    }
    
    func loadData() {
        Service.priority { booths in
            self.refreshControl?.endRefreshing()
            if booths != nil && booths!.count > 0 {
                self.booths = booths
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sg_category" {
//            let c = segue.destinationViewController as! CRCategoryViewController
//            c.category = categoryIndex
        } else if segue.identifier == "sg_main_detail" {
            let c = segue.destinationViewController as! CRDetailViewController
            let booth = sender as! CRBooth
            c.booth = booth
        }
    }
}
