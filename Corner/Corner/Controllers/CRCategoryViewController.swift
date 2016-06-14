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
    
    var searchController : UISearchController!

    @IBOutlet var filterButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Table view
        
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 3
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let helpCell = tableView.dequeueReusableCellWithIdentifier(r_CRHelpCell, forIndexPath: indexPath) as! CRHelpCell
        helpCell.updateContent()
        return helpCell
    }
    
    @IBAction func filterNearby(sender: AnyObject) {
        
    }
    
    @IBAction func filterCategory(sender: AnyObject) {
        
    }
    
    @IBAction func filterHot(sender: AnyObject) {
        
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
