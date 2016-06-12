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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "CRCategoryCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: r_CRCategoryCell)
        let helpCellNib = UINib.init(nibName: "CRHelpCell", bundle: nil)
        self.tableView.registerNib(helpCellNib, forCellReuseIdentifier: r_CRHelpCell)
        let url = "http://cdn.images.express.co.uk/img/dynamic/11/590x/Food-health-603127.jpg"
        images = [url, url, url, url]
        titles = ["附近","小吃","杂货","手艺"]
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
