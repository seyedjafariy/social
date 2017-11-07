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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let TAG = "FeedVC:"

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snap) in
            
            print("\(self.TAG) \(snap.value)")
        })
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
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
//

}
