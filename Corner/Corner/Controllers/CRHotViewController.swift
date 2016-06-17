//
//  CRHotViewController.swift
//  Corner
//
//  Created by dliu on 6/12/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit

class CRHotViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var ads: [UIViewController] = []
    
    var pc: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.loadad()
        self.initliaze()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) ->UIViewController? {
        if let index = ads.indexOf(viewController) {
            if index == 0 {
                return nil
            } else {
                return ads[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) ->UIViewController? {
        if let index = ads.indexOf(viewController) {
            if index == ads.count - 1 {
                return nil
            } else {
                return ads[index + 1]
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController],
transitionCompleted completed: Bool) {
        if let vc = self.viewControllers?.first {
            pc.currentPage = ads.indexOf(vc)!
        }
    }
    
    func loadad() {
        Service.recommend { booths in
            if booths != nil && booths!.count > 0 {
                for booth in booths! {
                    if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CR-AD-1") as? CRAdViewController {
                        vc.booth = booth
                        self.ads.append(vc)
                        self.setViewControllers([self.ads[0]], direction: .Forward, animated: true, completion: nil)
                        self.pc.numberOfPages = (booths?.count)!
                        self.pc.currentPage = 0
                    }
                }
            }
        }
    }
    
    func initliaze() {
        pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 0
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
}
