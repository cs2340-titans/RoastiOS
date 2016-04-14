//
//  MoreInformationTableViewController.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/13/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MoreInformationTableViewController: UITableViewController {
    
    let baseRef = Firebase(url: "https://roast-potato.firebaseio.com/")
    var loginViewController: FirebaseLoginViewController! = nil
    var currentUser: User! = nil
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "Profile") {
            segue.destinationViewController.navigationItem.title = "My Profile"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginViewController = FirebaseLoginViewController(ref: self.baseRef)
        self.loginViewController.enableProvider(.Password)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            if (self.loginViewController.currentUser() == nil) {
                self.presentViewController(self.loginViewController, animated: true, completion: nil)
            }
        }
        
        if (indexPath.section == 1 && indexPath.row == 2) {
            let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirm", style: .Destructive) {(action) in
                if (self.loginViewController.currentUser() != nil) {
                    self.loginViewController.logout()
                }
            })
            self.presentViewController(alert, animated: true, completion: nil)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
