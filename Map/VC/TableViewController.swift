//
//  TableViewController.swift
//  Map
//
//  Created by مي الدغيلبي on 21/03/1441 AH.
//  Copyright © 1441 مي الدغيلبي. All rights reserved.
//

import UIKit

class TableViewController:  UITableViewController{

    
    //Outlet
    @IBOutlet var table: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    

    var locations: Locations?
    {
    didSet {
    guard let locations = locations else { return }
     loc = locations.results
    }
    }
 

    var loc: [StudentLocation] = []{
    
    didSet {
        table.reloadData()
        }
    }

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self

    }

    
    override func viewWillAppear(_ animated: Bool) {
        
         makeRequest()
        }
    
    func makeRequest(){

        API.getAllLocations () {(studentsLocations, error) in
            
          
                
                if error != nil {
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                
                guard studentsLocations != nil else {
                    let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: "There was an error loading locations", preferredStyle: .alert )
                    
                    locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(locationsErrorAlert, animated: true, completion: nil)
                    return
                }
            }
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loc.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableID")!
        let arrloc = self.loc[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text =  "\( String(describing: arrloc.firstName)) \(String(describing: arrloc.lastName))"
        cell.textLabel?.text = arrloc.mediaURL
        return cell
    }

           override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let locationOfstudent = self.loc[ indexPath.row]
            openURL (url: locationOfstudent.mediaURL)
        
    }
    //*************************************
    func openURL(url:String?){
        guard let url = URL(string: url!) else { return }
        UIApplication.shared.open(url)
    }
    
 
    
    
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
    
    

}//end table View
