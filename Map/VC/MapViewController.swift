//
//  MapViewController.swift
//  Map
//
//  Created by مي الدغيلبي on 20/03/1441 AH.
//  Copyright © 1441 مي الدغيلبي. All rights reserved.
//

import UIKit
import MapKit



class MapViewController: UIViewController , MKMapViewDelegate  {

    
    //Outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
   var locations: Locations?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
  override func viewWillAppear(_ animated: Bool) {
    makeRequest()
    }
    
    
    
    //function perform request from API
     func makeRequest(){
        
        API.getAllLocations () {(studentsLocations, error) in
            
                guard  error == nil else{
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                var annotations = [MKPointAnnotation] ()
                
                guard let locationsArray = studentsLocations else {
                    let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: "There was an error loading locations", preferredStyle: .alert )
                    
                    locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(locationsErrorAlert, animated: true, completion: nil)
                    return
                }
                
                
                //Loop through the array of structs and get locations data from it so they can be displayed on the map
                for locationStruct in locationsArray {
                    
                    let long = CLLocationDegrees (locationStruct.longitude ?? 0)
                    let lat = CLLocationDegrees (locationStruct.latitude ?? 0)
                    
                    let coords = CLLocationCoordinate2D (latitude: lat, longitude: long)
                    
                    let mediaURL = locationStruct.mediaURL ?? " "
                    
                    let first = locationStruct.firstName ?? " "
                    
                    let last = locationStruct.lastName ?? " "
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coords
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append (annotation)
                }
                self.mapView.addAnnotations (annotations)
            }
            
    }//end getAllLocations
    
    
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
   //Actions
    @IBAction func update(_ sender: Any) {
        makeRequest()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        
        API.logoutUser { (error) in
           
            guard error == nil else{
                let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
        }
    }
    
    

    
    
}//end mapView
