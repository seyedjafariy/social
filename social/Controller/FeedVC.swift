//
//  FeedVC.swift
//  social
//
//  Created by ITParsa on 11/7/17.
//  Copyright © 2017 ITParsa. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {
    let TAG = "FeedVC:"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print ("\(self.TAG) sign out failed")
        }
        
        if let didRemove: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID){
            print("FeedVC: keychain removed: \(didRemove)")
        }
        
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "signOut", sender: nil)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
