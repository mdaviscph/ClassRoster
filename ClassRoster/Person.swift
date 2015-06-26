//
//  Person.swift
//  ClassRoster
//
//  Created by mike davis on 6/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
  var lastName: String
  var firstName: String
  var emailAddress: String?
  var image: UIImage?         // this seems to break the MVC pattern
  
  init(lastName: String, firstName: String, emailAddress: String?, image: UIImage?) {
    self.lastName = lastName
    self.firstName = firstName
    self.emailAddress = emailAddress
    self.image = image
  }
  convenience init(lastName: String, firstName: String) {
    self.init(lastName: lastName, firstName: firstName, emailAddress: nil, image: nil)
  }
  required convenience init(coder decoder: NSCoder) {
    if let lastName = decoder.decodeObjectForKey("lastName")as? String,
        firstName = decoder.decodeObjectForKey("firstName") as? String {
      let emailAddress = decoder.decodeObjectForKey("emailAddress") as? String
      let image = decoder.decodeObjectForKey("image") as? UIImage
          self.init(lastName: lastName, firstName: firstName, emailAddress: emailAddress, image: image)
    } else {
      self.init(lastName: "NLN", firstName: "NFN")
    }
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(lastName, forKey: "lastName")
    aCoder.encodeObject(firstName, forKey: "firstName")
    if let emailAddress = emailAddress {
      aCoder.encodeObject(emailAddress, forKey: "emailAddress")
    }
    if let image = image {
      aCoder.encodeObject(image, forKey: "image")
    }
  }
}