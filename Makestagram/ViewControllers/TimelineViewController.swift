//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Parth Shah on 23/06/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse


class TimelineViewController: UIViewController, UITabBarControllerDelegate,UITableViewDataSource {

	var photoTakingHelper: PhotoTakingHelper?
	@IBOutlet weak var tableView: UITableView!
	var posts = [Post]()
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let postsFromThisUser = Post.query()
		postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
		
		let followingQuery = PFQuery(className: "Follow")
		followingQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
		
		let postsFromFollowedUsers = Post.query()
		postsFromFollowedUsers!.whereKey("users", matchesKey: "toUser", inQuery: followingQuery)
		
		let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
		
		
		//We define that the combined query should also fetch the PFUser associated with a post. As you might remember, we are storing a pointer to a user object in the user column of each post. By using the includeKey method we tell Parse to resolve that pointer and download all the information about the user along with the post. We will need the username later when we display posts in our timeline.
		query.includeKey("user")
		
		
		query.orderByDescending("createdAt")
		
		query.findObjectsInBackgroundWithBlock{ (result: [PFObject]?, error: NSError?) -> Void in
			self.posts = result as? [Post] ?? []
			
			for post in self.posts {
				do {
					let data = try post.imageFile?.getData()
					post.image = UIImage(data: data!, scale:1.0)
				} catch {
					print("could not get image")
				}
			}

			
			self.tableView.reloadData()
		}

		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK: - Table View
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
		cell.postImageView.image = posts[indexPath.row].image
		
		return cell
	}
	
	
	
	//MARK: - Tab Bar Delegate
	
	func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
		if viewController is PhotoViewController{
			takePhoto()
			return false
		}else{
			return true
		}
	}
	
	func takePhoto(){
		// instantiate photo taking class, provide callback for when photo is selected
		photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController! ) { (image: UIImage?) in
			print("got a call back")
			let post = Post()
			post.image = image
			post.uploadPost()
		}
		
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
