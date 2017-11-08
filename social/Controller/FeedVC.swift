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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let TAG = "FeedVC:"
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var captionTxtField: SocialTxtField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImg: CircleView!
    var imgSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, andPreviousSiblingKeyWith: {(snapshot, string) in {
            print("\(self.TAG) \(snapshot.value)")
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                self.posts.removeAll()
                for snap in snapshots{
                    print ("\(self.TAG) snap= \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
            
            
            }}, withCancel: nil)
        
//        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
//            print("\(self.TAG) \(snapshot.value)")
//
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
//                self.posts.removeAll()
//                for snap in snapshots{
//                    print ("\(self.TAG) snap= \(snap)")
//                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
//                        let key = snap.key
//                        let post = Post(postKey: key, postData: postDict)
//                        self.posts.append(post)
//                    }
//                }
//            }
//            self.tableView.reloadData()
//        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            let post = posts[indexPath.row]
            print("\(TAG) post caption: \(post.caption)")
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configureCell(post: post, img: img)
                return cell
            }else {
                cell.configureCell(post: post)
                return cell
            }
            
        }else{
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            addImg.image = image
            imgSelected = true
        }else {
            print("\(TAG) image error received")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImgTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
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
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionTxtField.text, caption != "" else {
            print("\(TAG) caption must be entered")
            return
        }
        
        guard let img = addImg.image, imgSelected else {
            print("\(TAG) image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metaData, completion: {(metaData, error) in
                if error != nil{
                    print("\(self.TAG) image wasnt sent to firebase")
                }else {
                    print("\(self.TAG) image successfully sent to firebase")
                    
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    if let url = downloadUrl{
                        self.postToFirebase(imgUrl: url)
                    }
                }
            })
        }
    }
    
    func postToFirebase(imgUrl: String){
        let post : Dictionary<String, Any> = [
            "caption": captionTxtField.text!,
            "imageUrl": imgUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionTxtField.text = ""
        imgSelected = false
        addImg.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    
    
}


































