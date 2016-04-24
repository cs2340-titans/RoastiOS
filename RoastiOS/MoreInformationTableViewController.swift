//
//  MoreInformationTableViewController.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/13/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import UIKit
import Firebase

class MoreInformationTableViewController: UITableViewController {
    
    let baseRef = Firebase(url: "https://roast-potato.firebaseio.com/")
    var currentUser: User! = nil
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "Profile") {
            segue.destinationViewController.navigationItem.title = "My Profile"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.baseRef)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        switch indexPath.section {
        case 0: break
        
        case 1:
            switch indexPath.row {
            case 0:
                let alert = UIAlertController(title: "Registration", message: "Register a new account with email and password", preferredStyle: .Alert)
                alert.addTextFieldWithConfigurationHandler {
                    (emailField) -> Void in
                    emailField.placeholder = "user@example.com"
                }
                alert.addTextFieldWithConfigurationHandler {
                    (passwordField) -> Void in
                    passwordField.placeholder = "Password"
                    passwordField.secureTextEntry = true
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Confirm", style: .Default) {(action) in
                    self.baseRef.authUser(alert.textFields?[0].text, password: alert.textFields?[1].text, withCompletionBlock: nil)
                })
                self.presentViewController(alert, animated: true, completion: nil)
            case 1:
                let alert = UIAlertController(title: "Login", message: "Login with email and password", preferredStyle: .Alert)
                alert.addTextFieldWithConfigurationHandler {
                    (emailField) -> Void in
                    emailField.placeholder = "user@example.com"
                }
                alert.addTextFieldWithConfigurationHandler {
                    (passwordField) -> Void in
                    passwordField.placeholder = "Password"
                    passwordField.secureTextEntry = true
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Confirm", style: .Default) {(action) in
                    self.baseRef.createUser(alert.textFields?[0].text, password: alert.textFields?[1].text, withCompletionBlock: { (error) in
                        self.baseRef.authUser(alert.textFields?[0].text, password: alert.textFields?[1].text, withCompletionBlock: {
                            (error) in
                            let profileRef = self.baseRef.childByAppendingPath("profile/" + self.baseRef.authData.uid)
                            let defaultProfile = [
                                "email": "",
                                "fullname": "",
                                "gtid": "",
                                "major": ""
                            ]
                            profileRef.setValue(defaultProfile)
                        })
                        
                    })
                })
                self.presentViewController(alert, animated: true, completion: nil)
            case 2:
                let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Confirm", style: .Destructive) {(action) in
                    if (self.baseRef.authData != nil) {
                        self.baseRef.unauth()
                    }
                })
                self.presentViewController(alert, animated: true, completion: nil)
            default:
                break
            }
        default: break
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
