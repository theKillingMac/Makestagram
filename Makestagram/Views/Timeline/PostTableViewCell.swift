//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Parth Shah on 27/06/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {

	var post: Post? {
		didSet {
			postDisposable?.dispose()
			likeDisposable?.dispose()
			
			if let post = post {
				
				postDisposable = post.image.bindTo(postImageView.bnd_image)
				likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
					
					if let value = value {
						
						self.likesLabel.text = self.stringFromUserList(value)
						self.likeButton.selected = value.contains(PFUser.currentUser()!)
						self.likesIconImageView.hidden = (value.count == 0)
						
					} else {
						
						self.likesLabel.text = ""
						self.likeButton.selected = false
						self.likesIconImageView.hidden = true
					}
					
					
				}
			}
		}
	}
	
	@IBOutlet weak var postImageView: UIImageView!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var likesIconImageView: UIImageView!
	@IBOutlet weak var moreButton: UIButton!
	@IBOutlet weak var likeButton: UIButton!
	var postDisposable: DisposableType?
	var likeDisposable: DisposableType?
	
	
	@IBAction func moreButtontapped(sender: AnyObject) {
	
	}
	
	@IBAction func likeButtonTapped(sender: AnyObject) {
		post?.toggleLikePost(PFUser.currentUser()!)
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func stringFromUserList(userList: [PFUser]) -> String {
	
		let userList = userList.map{ user in user.username! }
		let commaSeperatedUserList = userList.joinWithSeparator(", ")
		return commaSeperatedUserList
		
	}

}
