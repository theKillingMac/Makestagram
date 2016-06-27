//
//  Post.swift
//  Makestagram
//
//  Created by Parth Shah on 24/06/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

//To create a custom Parse class you need to inherit from PFObject and implement the PFSubclassing protocol
class Post : PFObject, PFSubclassing {
	
	// Next, define each property that you want to access on this Parse class. For our Post class that's the user and the imageFile of a post. That will allow you to change the code that accesses properties through strings post["imageFile"] = imageFile into code that uses Swift properties post.imageFile = imageFile. Notice that we prefixed the properties with @NSManaged. This tells the Swift compiler that we won't initialize the properties in the initializer, because Parse will take care of it for us.
	@NSManaged var imageFile: PFFile?
	@NSManaged var user: PFUser?
	var photoUploadTask: UIBackgroundTaskIdentifier?
	
	
	//MARK: PFSubclassing Protocol
	
	// By implementing the parseClassName static function, you create a connection between the Parse class and your Swift class.
	static func parseClassName() -> String {
		return "Post"
	}
	
	// init and initialize are purely boilerplate code - copy these two into any custom Parse class that you're creating.
	override init () {
		super.init()
	}
	override class func initialize() {
		var onceToken : dispatch_once_t = 0;
		dispatch_once(&onceToken) {
			// inform Parse about this subclass
			self.registerSubclass()
		}
	}
	
	
	var image: UIImage?
	
	func uploadPost() {
		if let image = image {
			// When the uploadPost method is called, we grab the photo to be uploaded from the image property; turn it into a PFFile called imageFile. We used guard to exit the uploadPost() method early if creating the imageData or imageFile fail for some reason.
			guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
			guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
			
			user = PFUser.currentUser()
			self.imageFile = imageFile
			
			photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler{ () -> Void in
				UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
			}
			
			
			saveInBackgroundWithBlock{ (sucess: Bool, error: NSError?) in
				UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
			}
			
			
		}
	}
	
}