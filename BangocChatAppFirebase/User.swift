//
//  User.swift
//  BangocChatAppFirebase
//
//  Created by Ngoc on 10/11/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import Foundation

class User: NSObject{
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var id: String?
    
    override init(){
    }

    init(userName: String, userEmail: String, url: String) {
        self.name = userName
        self.email = userEmail
        self.profileImageUrl = url
    }
    
}
