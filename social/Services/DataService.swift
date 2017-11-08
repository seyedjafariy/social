//
//  DataService.swift
//  social
//
//  Created by ITParsa on 11/7/17.
//  Copyright © 2017 ITParsa. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    static let ds = DataService()
    
    //DB References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    //Storage REFERENCE
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference{
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: DatabaseReference{
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
    
        let user = REF_USERS.child(uid!)
        return user
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
}























