//
//  PersonList.swift
//  ClassRoster
//
//  Created by mike davis on 6/11/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import Foundation

class PersonList {
  var people = [Person]()
    
  func getCount() -> Int {
    return people.count
  }
  func isValidIndex(personIdx: Int) -> Bool {
    if personIdx >= 0 && personIdx < people.count {
      return true
    }
    return false
  }
  func getNameAtIndex(personIdx: Int) -> String {
    if isValidIndex(personIdx) {
      let person = people[personIdx]
      return "\(person.firstName) \(person.lastName)"
    }
    return String()
  }
  func getAtIndex(personIdx: Int) -> Person? {
    if isValidIndex(personIdx) {
      return people[personIdx]
    }
    else {
      return nil
    }
  }
  func removeAtIndex(personIdx: Int) -> Person? {
    if isValidIndex(personIdx) {
      let person = people.removeAtIndex(personIdx)
      return person
    }
    else {
      return nil
    }
  }
  func moveAtIndexToDestinationIndex(personIdx: Int, destinationPersonIdx: Int) -> Person? {
    
    if isValidIndex(personIdx) && isValidIndex(destinationPersonIdx) &&
        personIdx != destinationPersonIdx {
      
      let tempPerson = people[personIdx]
      var moveIdx = personIdx
  
      while (moveIdx < destinationPersonIdx) {
        people[moveIdx] = people[++moveIdx]
      }
      while (moveIdx > destinationPersonIdx) {
        people[moveIdx] = people[--moveIdx]
      }
      people[destinationPersonIdx] = tempPerson
      return tempPerson
    }      
    else {
      return nil
    }
  }
  
  func save(toArchiveFile fileName: String) -> Bool {
    var archiveFilePath = fileName
    var result = false
    if let docDirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? String {
      archiveFilePath = docDirPath.stringByAppendingPathComponent(fileName)
      if NSKeyedArchiver.archiveRootObject(people, toFile: archiveFilePath) {
        //println("saved Roster List to file: \(archiveFilePath)")
        println("saved Roster List to file")
        result = true
      }
    } else {
      println("cannot save Roster List to file: \(archiveFilePath)")
    }
    return result
  }
  // returns true if at least one person
  func read(fromArchiveFile fileName: String) -> Bool {
    var archiveFilePath = fileName
    var result = false
    if let docDirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as? String {
      archiveFilePath = docDirPath.stringByAppendingPathComponent(fileName)
      if (NSFileManager.defaultManager().fileExistsAtPath(archiveFilePath)) {
        
        //println("reading Roster List from file: \(archiveFilePath)")
        if let object: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(archiveFilePath),
            people = object as? [Person] {
          for person in people {
            self.people.append(person)
            result = true
            //if let emailAddress = person.emailAddress {
            //  println("  \(person.firstName) \(person.lastName) \(emailAddress)")
            //}
            //else {
            //  println("  \(person.firstName) \(person.lastName)")
            //}
          }
        }
      }
    } else {
      println("cannot read Roster List in file: \(archiveFilePath)")
    }
    return result
  }
  // returns true if at least one person
  func read(fromPlist name: String) -> Bool {
    var result = false
    if let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist"),
        personList = NSDictionary(contentsOfFile: path) as? [String:[[String:String]]] {
     for (section, peopleArray) in personList {
        for personData in peopleArray {
          //println("from plist: \(firstName) \(lastName) \(emailAddress)")
          if let firstName = personData["FirstName"],
              lastName = personData["LastName"] {
            let emailAddress = personData["EmailAddress"] // ok to be missing
            people.append(Person(lastName: lastName, firstName: firstName, emailAddress: emailAddress, image: nil))
            result = true
          }
        }
      }
    }
    else {
      println("cannot open initial data file \(name).plist")
    }
    return result
  }
}