//
//  User.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/13/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//
import Firebase


class User {
    var uid: String = "";
    var email: String = "";
    
    
    init(authData: FAuthData) {
        uid = authData.uid;
        email = authData.providerData["email"] as! String
    }
    
    
    init(uid: String, email: String) {
        
    }
}