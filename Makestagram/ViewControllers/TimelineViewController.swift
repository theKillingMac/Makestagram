//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Parth Shah on 23/06/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit


class TimelineViewController: UIViewController, UITabBarControllerDelegate,UITableViewDataSource, TimelineComponentTarget {

	var timelineComponent: TimelineComponent<Post, TimelineViewController>!

	var photoTakingHelper: PhotoTakingHelper?
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		timelineComponent.loadInitialIfRequired()

	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		timelineComponent = TimelineComponent(target: self)
		self.tabBarController?.delegate = self
	}

	
	//MARK: TimeLine
	let defaultRange = 0...4
	let additionalRangeSize = 5
	
	func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
		// 1
		ParseHelper.timelineRequestForCurrentUser(range) { (result: [PFObject]?, error: NSError?) -> Void in
			// 2
			let posts = result as? [Post] ?? []
			// 3
			completionBlock(posts)
		}
	}
	
	//MARK: - Table View
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return timelineComponent.content.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
		let post = timelineComponent.content[indexPath.row]
		post.downloadImage()
		post.fetchLikes()
		cell.post = post
		
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
			post.image.value = image!
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

extension TimelineViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		timelineComponent.targetWillDisplayEntry(indexPath.row)
	}
	
}
