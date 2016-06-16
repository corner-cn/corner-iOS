//
//  CRCategoryViewController.swift
//  Corner
//
//  Created by DY.Liu on 6/13/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

class CRCategoryViewController: UITableViewController,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    let r_CRHelpCell: String = "r_CRHelpCell"
    
    var booths: [CRBooth]?
    
    var distances: [Int] = [500, 1000, 2000, 5000]
    
    var categories: [String] = ["all", "snacks", "grocery", "handicraft"]
    var category_strs: [String] = ["全部类别", "小吃", "杂货", "手艺"]
    
    var orders:[String] = ["priority", "nearby", "check-in", "latest"]
    var order_strs: [String] = ["急需帮助", "距离最近", "热度最高", "最新发布"]
    
    var distance : Int!
    
    var category : String!
    
    var order: String!
    
    var searchController : UISearchController!
    
    @IBOutlet weak var distanceButton: CRExchangeButton!
    
    @IBOutlet weak var categoryButton: CRExchangeButton!
    
    @IBOutlet weak var orderButton: CRExchangeButton!
    
    @IBOutlet var sectionHeader: UIView!
    
    @IBOutlet var filterButtons: [UIButton]!
    
    @IBOutlet var pickView: CRFilterPickerView!
    
    var pickerWindow: UIWindow!
    
    var pickerViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)

        
        self.distance = self.distances.first
        self.category = self.categories.first
        self.order = self.orders.first
        
        let helpCellNib = UINib.init(nibName: "CRHelpCell", bundle: nil)
        self.tableView.registerNib(helpCellNib, forCellReuseIdentifier: r_CRHelpCell)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
        
        //Search Controller
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.tintColor = UIColor.whiteColor()
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        pickerWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        pickerWindow.makeKeyAndVisible()
        NSBundle.mainBundle().loadNibNamed("CRFilterPickerView", owner: self, options: nil)
        pickerWindow.addSubview(self.pickView)
        self.pickView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["picker": self.pickView]
        let constraintX = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[picker]-0-|", options: .AlignAllTop, metrics: nil, views: views)
        pickerWindow.addConstraints(constraintX)
        let constraintY = NSLayoutConstraint.constraintsWithVisualFormat("V:|-108-[picker]", options: .AlignAllTop, metrics: nil, views: views)
        pickerWindow.addConstraints(constraintY)
        self.pickerViewHeightConstraint = NSLayoutConstraint(item: self.pickView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200)
        self.pickView.addConstraint(self.pickerViewHeightConstraint)
        for button in self.filterButtons {
            button.setTitle("xxxx", forState: .Normal)
        }
    }
    
    //Search
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //todo
        print("\(searchController.searchResultsController)")
    }
    
    //MARK: Table view delegate & data source
    
    //    // MARK: - Table view data source
    //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if booths != nil {
            return (self.booths?.count)!
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let helpCell = tableView.dequeueReusableCellWithIdentifier(r_CRHelpCell, forIndexPath: indexPath) as! CRHelpCell
        helpCell.updateContent(self.booths![indexPath.row])
        return helpCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("sg_category_detail", sender: self.booths![indexPath.row])
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        NSBundle.mainBundle().loadNibNamed("CRCategoryTableSectionHeader", owner: self, options: nil)
        return sectionHeader
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func updateButtons() {
        var distanceButtonTitle: String = ""
        if self.distance >= 1000 {
            distanceButtonTitle = "\(self.distance/1000)km"
        } else {
            distanceButtonTitle = "\(self.distance)m"
        }
        self.distanceButton.setTitle(distanceButtonTitle, forState: .Normal)
        
        if let idx = self.categories.indexOf(self.category) {
            self.categoryButton.setTitle(self.category_strs[idx], forState: .Normal)
        }
        if let orderIdx = self.orders.indexOf(self.order) {
            self.orderButton.setTitle(self.order_strs[orderIdx], forState: .Normal)
        }
    }
    
    func refresh() {
        self.tableView.setContentOffset(CGPointMake(0, -(self.refreshControl?.frame.height)!), animated: true)
        self.refreshControl?.beginRefreshing()
        self.refreshControl?.sendActionsForControlEvents(.ValueChanged)
    }
    
    func loadData() {
        Service.boothsFilterByDistance(self.distance, category: self.category, order: self.order) {
            booths in
            self.refreshControl?.endRefreshing()
            if booths != nil && booths?.count > 0 {
                self.booths = booths
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func filterNearby(sender: AnyObject) {
        print("nearby")
    }
    
    @IBAction func filterCategory(sender: AnyObject) {
        print("category")
    }
    
    @IBAction func filterHot(sender: AnyObject) {
        print("hot")
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectFilter(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sg_category_detail" {
            let booth = sender as! CRBooth
            let c = segue.destinationViewController as! CRDetailViewController
            c.booth = booth
        }
    }
}
