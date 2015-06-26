//
//  ViewController.swift
//  ClassRoster
//
//  Created by mike davis on 6/18/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MLDDetailViewControllerUpdate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var editButton: UIBarButtonItem!
  
  var people = PersonList()
  let archiveFileName = "ClassRoster.bplist"
  let inBundleFileName = "InitRoster"
  
  var editMode = false
  var newOrChangedIndexPaths = [NSIndexPath]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if !people.read(fromArchiveFile: archiveFileName) {
      people.read(fromPlist: inBundleFileName)
    }
    tableView.dataSource = self
    tableView.delegate = self
    tableView.allowsSelection = false
    tableView.allowsSelectionDuringEditing = true
    editMode = false
    editButton.title = "Edit"
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // reload any cells that may have old data and save all to archive
    for indexPath in newOrChangedIndexPaths {
      println("reloading row \(indexPath.row)")
    }
    if !newOrChangedIndexPaths.isEmpty {
      tableView.reloadRowsAtIndexPaths(newOrChangedIndexPaths, withRowAnimation:.None)
      people.save(toArchiveFile: archiveFileName)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowPersonDetail" {
      if let detailVC = segue.destinationViewController as? PersonDetailViewController,
        indexPath = tableView.indexPathForSelectedRow() {
        detailVC.person = people.getAtIndex(indexPath.row)
        detailVC.indexPath = indexPath
        detailVC.updateDelegate = self
        newOrChangedIndexPaths = []
      }
    }
  }
  
  @IBAction func editButtonTapped(sender: AnyObject) {
    if editMode {
      tableView.setEditing(false, animated: true)
      editButton.title = "Edit"
    }
    else {
      tableView.setEditing(true, animated: true)
      editButton.title = "Done"
    }
    editMode = !editMode
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.getCount()
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("RosterCell", forIndexPath: indexPath) as? TableViewCell {
      cell.showsReorderControl = true
      if let person = people.getAtIndex(indexPath.row) {
        cell.setDisplay(person.firstName, last: person.lastName, image: person.image)
      }
      return cell
    }
    else {
      return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      if let person = people.removeAtIndex(indexPath.row) {
        println("deleted \(person.firstName) \(person.lastName)")
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        people.save(toArchiveFile: archiveFileName)
      }
    }
  }
  func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    if let person = people.moveAtIndexToDestinationIndex(sourceIndexPath.row, destinationPersonIdx: destinationIndexPath.row) {
      println("moved \(person.firstName) \(person.lastName) index: \(sourceIndexPath.row) to \(destinationIndexPath.row)")
      people.save(toArchiveFile: archiveFileName)
    }
  }
  
  func detailVC(viewController: PersonDetailViewController, newOrChangedIndexPath indexPath: NSIndexPath) {
    newOrChangedIndexPaths = [indexPath]
  }
}

protocol MLDDetailViewControllerUpdate {
  func detailVC(viewController: PersonDetailViewController, newOrChangedIndexPath indexPath: NSIndexPath)
}
