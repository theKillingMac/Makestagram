//
//  ParseHelper.swift
//  Makestagram
//
//  Created by Parth Shah on 27/06/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

class ParseHelper{
	
	// Following Relation
	static let ParseFollowClass       = "Follow"
	static let ParseFollowFromUser    = "fromUser"
	static let ParseFollowToUser      = "toUser"
	
	// Like Relation
	static let ParseLikeClass         = "Like"
	static let ParseLikeToPost        = "toPost"
	static let ParseLikeFromUser      = "fromUser"
	
	// Post Relation
	static let ParsePostUser          = "user"
	static let ParsePostCreatedAt     = "createdAt"
	
	// Flagged Content Relation
	static let ParseFlaggedContentClass    = "FlaggedContent"
	static let ParseFlaggedContentFromUser = "fromUser"
	static let ParseFlaggedContentToPost   = "toPost"
	
	// User Relation
	static let ParseUserUsername      = "username"
	
	
	
	static func timelineRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
		let followingQuery = PFQuery(className: ParseFollowClass)
		followingQuery.whereKey(ParseFollowFromUser, equalTo:PFUser.currentUser()!)
		
		let postsFromFollowedUsers = Post.query()
		postsFromFollowedUsers!.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
		
		let postsFromThisUser = Post.query()
		postsFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
		
		//We define that the combined query should also fetch the PFUser associated with a post. As you might remember, we are storing a pointer to a user object in the user column of each post. By using the includeKey method we tell Parse to resolve that pointer and download all the information about the user along with the post. We will need the username later when we display posts in our timeline.

		let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
		query.includeKey(ParsePostUser)
		query.orderByDescending(ParsePostCreatedAt)
		
		query.findObjectsInBackgroundWithBlock(completionBlock)
	
	}
	
	
	
	//MARK: Likes
	static func likePost(user: PFUser, post: Post) {
		let likeObject = PFObject(className: ParseLikeClass)
		likeObject[ParseLikeFromUser] = user
		likeObject[ParseLikeToPost] = post
		likeObject.saveInBackgroundWithBlock(nil)
	}
	
	static func unlikePost(user: PFUser, post: Post) {
		let query = PFQuery(className: ParseLikeClass)
		query.whereKey(ParseLikeFromUser, equalTo: user)
		query.whereKey(ParseLikeToPost, equalTo: post)
		
		query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
			
			if let results = results {
				for like in results {
					like.deleteInBackgroundWithBlock(nil)
				}
			}
		}
	}
	
	static func likesForPost(post: Post, completionBlock: PFQueryArrayResultBlock) {
		let usersForLikedPosts = PFQuery(className: ParseLikeClass)
		usersForLikedPosts.whereKey(ParseLikeToPost, equalTo: post)
		usersForLikedPosts.includeKey(ParseLikeFromUser)
		
		usersForLikedPosts.findObjectsInBackgroundWithBlock(completionBlock)
	}
		
	
}

extension PFObject {
	
	public override func isEqual(object: AnyObject?) -> Bool {
		if (object as? PFObject)?.objectId == self.objectId {
			return true
		} else {
			return super.isEqual(object)
		}
	}
	
}