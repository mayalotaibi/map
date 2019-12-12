//
//  AddLocationViewController.swift
//  Map
//
//  Created by مي الدغيلبي on 28/03/1441 AH.
//  Copyright © 1441 مي الدغيلبي. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController ,UITextFieldDelegate {

    
    @IBOutlet weak var iconMap: UIImageView!
    @IBOutlet weak var reginText: UITextField!
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reginText.delegate = self
        urlText.delegate = self
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
      
        let location = reginText.text!
        let urlLocation = urlText.text!
        
        if location == " " || urlLocation == " " {
            
            let alertController = UIAlertController(title: "Missing information", message: "Please fill both fields ", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        else{

            let stLocation = StudentLocation ( mapString: location , mediaURL: urlLocation)
        geocodeCoordinates(stLocation)

}
    }
    
    
    
     func geocodeCoordinates(_ stLocation: StudentLocation) {

       let ActivityIndicator = startAnActivityIndicator()
         //Use CLGeocoder's function named `geocodeAddressString` to convert location's `mapString` to coordinates
        
        CLGeocoder().geocodeAddressString(stLocation.mapString! ){
            (placeMarks , err) in
        
            // Call `ai.stopAnimating()` first thing in the completionHandler
            ActivityIndicator.stopAnimating()

            // Extract the first location from Place Marks array
            guard let firstLocation = placeMarks?.first?.location else {return}
            
            // Copy studentLocation into a new object and save latitude and longitude in the new object's properties `latitude` and `longitude`
            var locatioObj = stLocation
            locatioObj.latitude = firstLocation.coordinate.latitude
            locatioObj.longitude = firstLocation.coordinate.longitude
            
            
            
            
            self.performSegue(withIdentifier: "ToPostView", sender: locatioObj)
        }
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPostView" ,
            let vc = segue.destination as? PostLocationViewController
        
             {
                vc.loc = sender as? StudentLocation
        }
    }
    
  
    
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        
        let activityIndicatir = UIActivityIndicatorView(style: .gray)
        
        view.addSubview(activityIndicatir)
        view.bringSubviewToFront(activityIndicatir)
        activityIndicatir.center = self.view.center
        activityIndicatir.hidesWhenStopped = true
        
        activityIndicatir.startAnimating()
        
        return activityIndicatir
    }

 
}

