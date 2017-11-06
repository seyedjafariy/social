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

class SignInVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                print(error)
            }else {
                print ("SIGNINVC: firebase success")
            }
        })
        
    }

}

