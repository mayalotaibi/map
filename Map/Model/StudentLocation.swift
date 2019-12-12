//
//  StudentLocation.swift
//  Map
//
//  Created by مي الدغيلبي on 20/03/1441 AH.
//  Copyright © 1441 مي الدغيلبي. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    var createdAt :String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL: String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt: String?
}

extension StudentLocation {

init ( mapString: String,
    mediaURL: String){
    self.mapString = mapString
     self.mediaURL = mediaURL
}
}
