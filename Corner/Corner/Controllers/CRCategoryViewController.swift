//
//  CRCategoryViewController.swift
//  Corner
//
//  Created by DY.Liu on 6/13/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class CRCategoryViewController: UITableViewController,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    let r_CRHelpCell: String = "r_CRHelpCell"
    let r_CRSimpleCell: String = "r_SimpleCell"
    
    var booths: [CRBooth] = []
    var searchedBooths: [CRBooth] = []
    
    var distances: [Int] = [500, 1000, 2000, 5000]
    var distance_strs: [String] = ["500m", "1km", "2km", "5km"]
    
    var categories: [String] = ["all", "snacks", "grocery", "handicraft"]
    var category_strs: [String] = ["全部类别", "小吃", "杂货", "手艺"]
    
    var orders:[String] = ["priority", "nearby", "check-in", "latest"]
    var order_strs: [String] = ["急需帮助", "距离最近", "热度最高", "最新发布"]
    
    var distance : Int!
    
    var category : String!
    
    var order: String!
    
    @IBOutlet weak var distanceButton: CRExchangeButton!
    
    @IBOutlet weak var categoryButton: CRExchangeButton!
    
    @IBOutlet weak var orderButton: CRExchangeButton!
    
    @IBOutlet var sectionHeader: UIView!
    
    @IBOutlet var filterButtons: [UIButton]!
    
    @IBOutlet var pickView: CRFilterPickerView!
    
    var pickerWindow: UIWindow!
    
    var pickerViewHeightConstraint: NSLayoutConstraint!
    
    var searchController : UISearchController!
    
    var historyKeywords: [String]! = ["大妈", "三里屯", "朝阳区"]
    
    var showSearchResult: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)
        
        self.distance = self.distances.first
        self.category = self.categories.first
        self.order = self.orders.first
        
        let helpCellNib = UINib.init(nibName: "CRHelpCell", bundle: nil)
        self.tableView.registerNib(helpCellNib, forCellReuseIdentifier: r_CRHelpCell)
        let simpleCellNib = UINib(nibName: "CRSimpleCell", bundle: nil)
        self.tableView.registerNib(simpleCellNib, forCellReuseIdentifier: r_CRSimpleCell)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
        
        //Search Controller
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
//        self.searchController.searchBar.tintColor = UIColor.whiteColor()
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 9.1, *) {
            self.searchController.obscuresBackgroundDuringPresentation = false
        } else {
            self.searchController.dimsBackgroundDuringPresentation = false
        }
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        
        self.setupPickerView()
        
        self.refresh()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.pickerWindow != nil {
            self.hidePickerView()
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if let refreshing = self.refreshControl?.refreshing {
            if refreshing {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func setupPickerView() {
        var frame = UIScreen.mainScreen().bounds
        frame.origin.y = 108.0
        pickerWindow = UIWindow(frame:frame)
//        pickerWindow.translatesAutoresizingMaskIntoConstraints = false
        let tapgz = UITapGestureRecognizer(target: self, action: #selector(hidePickerView))
        pickerWindow.addGestureRecognizer(tapgz)
        NSBundle.mainBundle().loadNibNamed("CRFilterPickerView", owner: self, options: nil)
        pickerWindow.addSubview(self.pickView)
        self.pickView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["picker": self.pickView]
        let constraintX = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[picker]-0-|", options: .AlignAllTop, metrics: nil, views: views)
        pickerWindow.addConstraints(constraintX)
        let constraintY = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-108)-[picker]", options: .AlignAllTop, metrics: nil, views: views)
        pickerWindow.addConstraints(constraintY)
        self.pickerViewHeightConstraint = NSLayoutConstraint(item: self.pickView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0)
        self.pickView.addConstraint(self.pickerViewHeightConstraint)
    }
    
    func showPickerView(filterType: Int) {
        self.pickerWindow.makeKeyAndVisible()
        self.pickView.type = filterType
        switch filterType {
        case 1:
            self.setButtonTitles(self.distance_strs)
        case 2:
            self.setButtonTitles(self.category_strs)
        case 3:
            self.setButtonTitles(self.order_strs)
        default:
            return
        }
        self.pickerWindow.layoutIfNeeded()
        UIView.animateWithDuration(0.3, animations: {
            self.pickerViewHeightConstraint.constant = 200.0
            self.pickerWindow.layoutIfNeeded()
        }, completion: {result in
            self.pickView.setNeedsDisplay()
        })
    }
    
    func setButtonTitles(titles: [String]) {
        if titles.count == self.filterButtons.count {
            for index in 0...titles.count - 1 {
                self.filterButtons[index].setTitle(titles[index], forState: .Normal)
            }
        }
    }

    func hidePickerView() {
        self.pickerWindow.layoutIfNeeded()
        UIView.animateWithDuration(0.3, animations: {
            self.pickerViewHeightConstraint.constant = 0.0
            self.pickerWindow.layoutIfNeeded()
        }, completion: {result in
            self.view.window?.makeKeyAndVisible()
        })
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
                self.booths = booths!
                self.tableView.reloadData()
            }
        }
    }
    
    func search(keyword: String) {
        self.showSearchResult = true
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Service.search(keyword: keyword) { booths in
            hud.hide(true)
            if booths != nil && booths!.count > 0 {
                self.searchedBooths = booths!
            } else {
                self.searchedBooths = [] //reset
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func filterNearby(sender: AnyObject) {
        self.showPickerView(1)
    }
    
    @IBAction func filterCategory(sender: AnyObject) {
        self.showPickerView(2)
    }
    
    @IBAction func filterHot(sender: AnyObject) {
        self.showPickerView(3)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectFilter(sender: UIButton) {
        if let index = self.filterButtons.indexOf(sender) {
            self.hidePickerView()
            switch self.pickView.type! {
            case 1:
                distance = self.distances[index]
                self.distanceButton.setTitle(self.distance_strs[index], forState: .Normal)
            case 2:
                category = self.categories[index]
                self.categoryButton.setTitle(self.category_strs[index], forState: .Normal)
            case 3:
                order = self.orders[index]
                self.orderButton.setTitle(self.order_strs[index], forState: .Normal)
            default: break
            }
        }
        self.refresh()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sg_category_detail" {
            let booth = sender as! CRBooth
            let c = segue.destinationViewController as! CRDetailViewController
            c.booth = booth
        }
    }
    
    //Search
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {

        print("\(searchController.searchBar.text)")
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        self.hidePickerView()
    }

    
    func didPresentSearchController(searchController: UISearchController) {
        self.tableView.reloadData()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        self.showSearchResult = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.search(searchBar.text!)
    }

    
    //MARK: Table view delegate & data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.active) {
            return self.showSearchResult ? self.searchedBooths.count : self.historyKeywords.count
        } else {
            return self.booths.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.searchController.active {
            if self.showSearchResult {
                let resultCell = tableView.dequeueReusableCellWithIdentifier(r_CRHelpCell, forIndexPath: indexPath) as! CRHelpCell
                resultCell.updateContent(self.searchedBooths[indexPath.row])
                return resultCell
            } else {
                let keywordCell = tableView.dequeueReusableCellWithIdentifier(r_CRSimpleCell, forIndexPath: indexPath) as! CRSimpleCell
                keywordCell.crLabel.text = self.historyKeywords[indexPath.row]
                return keywordCell
            }
        } else {
            let helpCell = tableView.dequeueReusableCellWithIdentifier(r_CRHelpCell, forIndexPath: indexPath) as! CRHelpCell
            helpCell.updateContent(self.booths[indexPath.row])
            return helpCell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.searchController.active {
            if self.showSearchResult {
                self.performSegueWithIdentifier("sg_category_detail", sender: self.searchedBooths[indexPath.row])
            } else {
                let keyword = historyKeywords[indexPath.row]
                self.searchController.searchBar.text = keyword
                self.search(keyword)
                self.searchController.searchBar.resignFirstResponder()
            }
        } else {
            self.performSegueWithIdentifier("sg_category_detail", sender: self.booths[indexPath.row])
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.searchController.active) {
            return nil
        } else {
            if sectionHeader == nil {
                NSBundle.mainBundle().loadNibNamed("CRCategoryTableSectionHeader", owner: self, options: nil)
            }
            return sectionHeader
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchController.active {
            return 0.0
        } else {
            return 44.0
        }
    }
}
