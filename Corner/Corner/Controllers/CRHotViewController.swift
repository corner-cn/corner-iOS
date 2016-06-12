//
//  CRHotViewController.swift
//  Corner
//
//  Created by dliu on 6/12/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

class CRHotViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var ads: NSMutableArray = []
    
    var pc: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.loadad()
        self.initliaze()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) ->UIViewController? {
        let index = ads.indexOfObject(viewController)
        if index == 0 {
            return nil
        } else {
            return ads.objectAtIndex(index - 1) as? UIViewController
        }
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) ->UIViewController? {
        let index = ads.indexOfObject(viewController)
        if index == ads.count - 1 {
            return nil
        } else {
            return ads.objectAtIndex(index + 1) as? UIViewController
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
transitionCompleted completed: Bool) {
        if let vc = self.viewControllers?.first {
            pc.currentPage = ads.indexOfObject(vc)
        }
    }
    
    func loadad() {
        for _ in 0...2 {
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CR-AD-1") {
                ads.addObject(vc)
            }
        }
        self.setViewControllers([ads[0] as! UIViewController], direction: .Forward, animated: true, completion: nil)
    }
    
    func initliaze() {
        pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3
        pc.currentPageIndicatorTintColor = UIColor(red: 65.0/255, green: 193.0/255, blue: 176.0/255, alpha: 1.0)
        pc.layer.zPosition = 999
        pc.translatesAutoresizingMaskIntoConstraints = false
        self.view .addSubview(pc)
        let views = ["pc" : pc]
        let xConstraints = NSLayoutConstraint.init(item: pc, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let yConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[pc]-0-|", options:.AlignAllTop, metrics: nil, views: views)
        self.view.addConstraint(xConstraints)
        self.view.addConstraints(yConstraints)
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
