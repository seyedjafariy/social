//
//  PostCell.swift
//  social
//
//  Created by ITParsa on 11/7/17.
//  Copyright © 2017 ITParsa. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var captionTxt: UITextView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var usernameImg: UILabel!
    @IBOutlet weak var profileImg: CircleView!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        
        self.captionTxt.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
        if img != nil{
            self.postImg.image = img
        }else {
            if let imageUrl = post.imageUrl as String?{
                let ref = Storage.storage().reference(forURL: imageUrl)
                
                ref.getData(maxSize: 2 * 1024 * 1024, completion: {(data, error) in
                    if error != nil {
                        print("image failed to download from storage")
                    }else {
                        print("image succesfully downloaded")
                        if let imgData = data {
                            if let img = UIImage(data: imgData){
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            }
                        }
                    }
                })
            }
            
        }
        
    }

}
