//
//  CRMapViewController.swift
//  Corner
//
//  Created by DY.Liu on 6/17/16.
//  Copyright © 2016 ijiejiao. All rights reserved.
//

import UIKit
import MapKit

class CRMapViewController: UIViewController, MKMapViewDelegate {

    var booth: CRBooth?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let la = booth?.latitude, lo = booth?.longitude {
            let locatoin = CLLocationCoordinate2D(latitude:la, longitude: lo)
            let region = MKCoordinateRegionMakeWithDistance(locatoin, 1000, 1000)
            let adjusted_region = self.mapView.regionThatFits(region)
            self.mapView.setRegion(adjusted_region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locatoin
            annotation.title = booth?.location
            self.mapView.addAnnotation(annotation)
        }
    }

    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
        self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
    }
}
