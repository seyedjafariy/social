//
//  ViewController.swift
//  social
//
//  Created by ITParsa on 11/6/17.
//  Copyright © 2017 ITParsa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTxtField: SocialTxtField!
    @IBOutlet weak var passTxtField: SocialTxtField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let uid = KeychainWrapper.standard.string(forKey: KEY_UID){
            print("SINGINVC: uid found: \(uid)")
            
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "goToFeeds", sender: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func fbBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: {(result, error) in
            if error != nil {
                print("SIGNINVC: unable to authenticate with facebook")
            }else if result?.isCancelled == true{
                print("SIGNINVC: user canceled auth")
            } else{
                print("SIGNINVC: success with facbook auth")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        })
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if error != nil{
                print ("SIGNINVC: firebase failed")
                print(error!)
            }else {
                print ("SIGNINVC: firebase success")
                if let user = user{
                    self.completeSignIn(uid: user.uid)
                }
            }
        })
        
    }
    
    @IBAction func emailSignIn(_ sender: Any) {
        if let email = emailTxtField.text, let pass = passTxtField.text{
            Auth.auth().signIn(withEmail: email, password: pass, completion: {(user, error) in
                if error == nil{
                    print("SIGNINVC: user authenticated using email and pass")
                    print(user!)
                    if let user = user {
                        self.completeSignIn(uid: user.uid)
                    }
                    
                }else {
                    print("SIGNINVC: user sign in failed with firebase using email and pass")
                    print(error!)
                    
                    Auth.auth().createUser(withEmail: email, password: pass, completion: {(user, error) in
                        if error != nil {
                            print(error!)
                            print("SIGNINVC: user unable to create auth using email and pass")
                        }else {
                            print(user!)
                            print("SIGNINVC: user success creating authenticated using email and pass")
                            if let user =  user {
                                self.completeSignIn(uid: user.uid)
                            }
                            
                        }
                    })
                    
                }
                
            })
        }
    }
    
    func completeSignIn(uid id: String){
        let success = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print ("saving in the keychain was a success: \(success)")
        performSegue(withIdentifier: "goToFeeds", sender: nil)
    }
}


































