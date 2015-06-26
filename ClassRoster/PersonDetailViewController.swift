//
//  PersonDetailViewController.swift
//  ClassRoster
//
//  Created by mike davis on 6/18/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  var person: Person?
  var indexPath: NSIndexPath?
  var updateDelegate: MLDDetailViewControllerUpdate?
  
  @IBOutlet weak var buttonProfileImage: UIButton!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailAddressTextField: UITextField!
  @IBOutlet weak var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    firstNameTextField.delegate = self
    lastNameTextField.delegate = self
    emailAddressTextField.delegate = self
    
    firstNameTextField.text = person?.firstName
    lastNameTextField.text = person?.lastName
    if let emailAddress = person?.emailAddress {
      emailAddressTextField.text = emailAddress
    }
    buttonProfileImage.imageView?.contentMode = .ScaleAspectFill
    if let image = person?.image {
      buttonProfileImage.setImage(image, forState: .Normal)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    startObservingKeyboardEvents()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    stopObservingKeyboardEvents()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // use Editing Changed because other IBActions will be after parent VC
  // viewWillAppear() when leaving this VC without moving off of text field
  @IBAction func firstNameEditingChanged(sender: AnyObject) {
    person?.firstName = firstNameTextField.text
    callUpdateDelegate()
  }
  @IBAction func lastNameEditingChanged(sender: AnyObject) {
    person?.lastName = lastNameTextField.text
    callUpdateDelegate()
  }
  @IBAction func emailAddressEditingChanged(sender: AnyObject) {
    if !emailAddressTextField.text.isEmpty {
      person?.emailAddress = emailAddressTextField.text
    }
    else {
      person?.emailAddress = nil
    }
    callUpdateDelegate()
  }
  
  @IBAction func firstNameDidEndOnExit(sender: AnyObject) {
    lastNameTextField.becomeFirstResponder()
  }
  @IBAction func lastNameDidEndOnExit(sender: AnyObject) {
    emailAddressTextField.becomeFirstResponder()
  }
  // will result in behind-the-scenes resignFirstResponder call
  @IBAction func emailAddressDidEndOnExit(sender: AnyObject) {
  }
  // needed for above IBActions handling the FirstResponder movement
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    return true
  }
  
  @IBAction func profileImageTapped(sender: AnyObject) {
    startImagePicker()
  }
  @IBAction func editImageTapped(sender: AnyObject) {
    startImagePicker()
  }
  
  func startImagePicker() {
    let imagePC = UIImagePickerController()
    imagePC.delegate = self
    imagePC.allowsEditing = true
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      imagePC.sourceType = .Camera
    }
    else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
      imagePC.sourceType = .SavedPhotosAlbum
    }
    else {
      imagePC.sourceType = .PhotoLibrary
    }
    presentViewController(imagePC, animated: true, completion: nil)
  }
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      picker.dismissViewControllerAnimated(true, completion: nil)
      buttonProfileImage.setImage(image, forState: .Normal)
      person?.image = image
    }
    else {
      person?.image = nil
    }
    callUpdateDelegate()
  }
  
  // keyboard may overlap the text field
  func startObservingKeyboardEvents() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWillShow:"),
      name:UIKeyboardWillShowNotification, object:nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWillHide:"),
      name:UIKeyboardWillHideNotification, object:nil)
  }
  func stopObservingKeyboardEvents() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  // adjust the scroll view so text field is visible
  func keyboardWillShow(notification: NSNotification) {
    if let userInfo = notification.userInfo,
      keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
        //println("kWS offset: \(scrollView.contentOffset.description) inset: \(scrollView.contentInset.description)")
        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        //println("change to: \(scrollView.contentInset.description)")
    }
  }
  func keyboardWillHide(notification: NSNotification) {
    //println("kWH offset: \(scrollView.contentOffset.description) inset: \(scrollView.contentInset.description)")
    scrollView.contentInset = UIEdgeInsetsZero
    //println("change to: \(UIEdgeInsetsZero.description)")
  }
  
  func callUpdateDelegate() {
    if let delegate = updateDelegate,
      indexPath = indexPath {
        updateDelegate?.detailVC(self, newOrChangedIndexPath: indexPath)
    }
  }
}

extension UIEdgeInsets {
  var description: String {
    get {
      return "top:\(Int(self.top)) left:\(Int(self.left)) bottom:\(Int(self.bottom)) right:\(Int(self.right))"
    }
  }
}
extension CGPoint {
  var description: String {
    get {
      return "x:\(Int(self.x)) y:\(Int(self.y))"
    }
  }
}
