//
//  FirstViewController.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/5/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController {
    
    let baseRef = Firebase(url: "https://roast-potato.firebaseio.com/")
    var loginViewController: FirebaseLoginViewController! = nil
    var currentUser: User! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let firebaseRef = Firebase(url: "https://roast-potato.firebaseio.com/")
        self.loginViewController = FirebaseLoginViewController(ref: firebaseRef)
        self.loginViewController.enableProvider(FAuthProvider.Password)
        self.loginViewController.didDismissWithBlock { (user: FAuthData!, error: NSError!) -> Void in
            if ((user) != nil) {
                self.currentUser = User(authData: user)
                print(self.currentUser)
            } else if ((error) != nil) {
                print(error)
            } else {
                print("cancled")
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if ((self.loginViewController.currentUser() == nil)) {
            self.presentViewController(self.loginViewController, animated: true, completion: nil)
        } else {
            self.currentUser = User(authData: self.loginViewController.currentUser())
            print(self.currentUser.email)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

