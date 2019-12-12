//
//  PostLocationViewController.swift
//  Map
//
//  Created by مي الدغيلبي on 30/03/1441 AH.
//  Copyright © 1441 مي الدغيلبي. All rights reserved.
//

import UIKit
import MapKit


class PostLocationViewController: UIViewController , MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var funishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var loc: StudentLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    
    @IBAction func Finish(_ sender: Any) {
        
        API.postlocationUser { (loc, error) in
            
                guard  error == nil else{
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: " failed network connection", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                self.dismiss(animated: true, completion: nil)

                
                }
        }
    
    
    
    
    
    @IBAction func Cancel(_ sender: Any) {
        
         self.dismiss(animated: true, completion: nil)
    }
    
    
  func setLocation(){
    
    
    guard let loc = loc else { return }
    
    let lat = CLLocationDegrees(loc.latitude!)
    let long = CLLocationDegrees(loc.longitude!)
    
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
    /// Create a new MKPointAnnotation
    
    let annotation =  MKPointAnnotation()
    
    // Set annotation's `coordinate` and `title` properties to the correct coordinate and `location.mapString` respectively
    
    
    annotation.coordinate.latitude = loc.latitude!
    annotation.coordinate.longitude = loc.longitude!
    annotation.title = "\(String(describing: loc.firstName)) \(String(describing: loc.lastName))"
    
    
    //  Add annotation to the `mapView`
    mapView.addAnnotation(annotation)
    
    // Setting current mapView's region to be centered at the pin's coordinate
    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    mapView.setRegion(region, animated: true)
}

    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
}


 
}
        

