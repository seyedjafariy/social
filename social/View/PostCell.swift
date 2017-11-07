//
//  PostCell.swift
//  social
//
//  Created by ITParsa on 11/7/17.
//  Copyright © 2017 ITParsa. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var captionTxt: UITextView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var usernameImg: UILabel!
    @IBOutlet weak var profileImg: CircleView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
