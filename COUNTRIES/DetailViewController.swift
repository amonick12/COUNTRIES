//
//  DetailViewController.swift
//  COUNTRIES
//
//  Created by Aaron Monick on 8/18/15.
//  Copyright (c) 2015 MONIX. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var countries: [Country]?
    var country: Country?
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        mapView.delegate = self
        if country != nil {
            loadMap()
            centerMapOnCountry()
            if let index = find(countries!, country!) {
                mapView.selectAnnotation(countries![index], animated: true)
            }
        } else {
            centerMapOnLocation(initialLocation)
        }
    }
    
    func loadMap() {
        if countries != nil {
            for c in countries! {
                mapView.addAnnotation(c)
            }
        }
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Country {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    func centerMapOnCountry() {
        if country != nil {
            if country!.lat != nil && country!.long != nil {
                let location = CLLocation(latitude: country!.lat!, longitude: country!.long!)
                centerMapOnLocation(location)
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

