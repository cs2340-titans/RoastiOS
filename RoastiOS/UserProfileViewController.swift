//
//  UserProfileViewController.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/14/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UITableViewController, UITextFieldDelegate {
    
    let baseRef = Firebase(url: "https://roast-potato.firebaseio.com/")
    var userProfileRef: Firebase? = nil
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var gtid: UITextField!
    @IBOutlet weak var major: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fields = [self.email, self.fullName, self.gtid, self.major]
        
        
        for field in fields {
            field.delegate = self
            field.addTarget(self, action: #selector(UserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        }
        
        let uid = baseRef.authData.uid
        let path = "profile/" + uid
        self.userProfileRef = baseRef.childByAppendingPath(path)
        userProfileRef!.observeEventType(.Value, withBlock: { snapshot in
            self.email.text = snapshot.value.objectForKey("email") as? String ?? ""
            self.fullName.text = snapshot.value.objectForKey("fullname") as? String ?? ""
            self.gtid.text = snapshot.value.objectForKey("gtid") as? String ?? ""
            self.major.text = snapshot.value.objectForKey("major") as? String ?? ""
        })
    }

    func textFieldDidChange(textField: UITextField) {
        if textField == email {
            self.userProfileRef!.childByAppendingPath("email").setValue(textField.text!)
        }
        if textField == fullName {
            self.userProfileRef!.childByAppendingPath("fullname").setValue(textField.text!)
        }
        if textField == gtid {
            self.userProfileRef!.childByAppendingPath("gtid").setValue(textField.text!)
        }
        if textField == major {
            self.userProfileRef!.childByAppendingPath("major").setValue(textField.text!)
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // Handle "next" buttons
        if textField == email {
            fullName.becomeFirstResponder()
        }
        if textField == fullName {
            gtid.becomeFirstResponder()
        }
        if textField == gtid {
            major.becomeFirstResponder()
        }
        
        
        return true
    }
}
