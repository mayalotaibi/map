//
//  API.swift
//  Map
//
//  Created by مي الدغيلبي on 14/03/1441 AH.
//  Copyright © 1441 مي الدغيلبي. All rights reserved.
//

import Foundation


class API{
    
    
    private static var userInfo = InformationOfUser()
    private static var sessionId: String?
   
    
    //#1
    static func login(username: String, password: String, completion: @escaping (String?)->Void) {
        
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/session") else {
            completion("Supplied url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errorString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dictionary = json as? [String:Any],
                        let sessionDictionary = dictionary["session"] as? [String: Any],
                        let accountDictionary = dictionary["account"] as? [String: Any]  {
                        
                        self.userInfo.key = accountDictionary["key"] as? String
                        self.sessionId = sessionDictionary["id"] as? String
                        
                        self.getUserInfo(completion: { err in
                            
                        })
                    } else {
                        errorString = "Couldn't parse response"
                    }
                } else {
                    errorString = "Provided login credintials didn't match our records"
                }
            } else {
                errorString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errorString)
            }
            
        }
        task.resume()
    }
    
   
    
    //#2
    static func getAllLocations (completion: @escaping ([StudentLocation]?, Error?) -> ()) {
        
        var request = URLRequest (url: URL (string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if error != nil {
                
                completion (nil, error)
                return
            }
            
            print (String(data: data!, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (nil, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                
                //Check if the result array is nil using guard let, if it's return, otherwise continue
                guard let array = resultsArray else {return}
                
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                
                //Use JSONDecoder to convert dataObject to an array of structs
                let studentsLocations = try! JSONDecoder().decode([StudentLocation].self, from: dataObject)
                
                completion (studentsLocations, nil)
            }
        }
        
        task.resume()
    }
    
    
    
    //#3
    
    static func getUserInfo( completion: @escaping (Error?)->Void) {
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            //Get the status code to check if the response is OK or not
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (statusCodeError)
                return
            }
            
            if statusCode >= 200  && statusCode < 300 {
                
                let newData = data?.subdata(in: 5..<data!.count)
                
                //Print the data to see it and know you'll parse it (this can be removed after you complete building the app)
                print (String(data: newData!, encoding: .utf8)!)
                
                let JsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])
                
                let Dictionary = JsonObject as? [String : Any]
                
                //Get the fisrt name of the user
                let userDictionary = Dictionary? ["user"] as? [String : Any]
                
                let lasttName = userDictionary? ["last_name"] as? String ?? " "
                let firstName = userDictionary? ["first_name"] as? String ?? " "
                
                print ("First Name: ",firstName, "Last Name: ",lasttName )
                
                
            } else {
                completion (error)
            }
        }
        task.resume()
    }
    
    
    
    
    //#4
    
    static func postlocationUser(completion: @escaping (_ location: StudentLocation , Error?) -> ()) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(1234)\", \"mapString\":\"\(StudentLocation.self)\"}".data(using: .utf8)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
                var errorString: String?
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode >= 200 && statusCode < 300 { //Response is ok
            
                        print("Sucessful Opreation")

                    }else{
                        errorString = "Invalid URL"


                    }
                }else {
                    errorString = "Check your internet connection"
                }
            
               DispatchQueue.main.async {
                completion(StudentLocation(), errorString as? Error)
               }
        }
        task.resume()
    }
    
    
    //#5
    static func logoutUser(completion: @escaping (Error?)->Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        DispatchQueue.main.async {
            completion(nil)
        }
        task.resume()
        
        
    }
    
}//end class API

