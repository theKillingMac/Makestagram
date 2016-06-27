//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Parth Shah on 23/06/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse


class TimelineViewController: UIViewController, UITabBarControllerDelegate {

	var photoTakingHelper: PhotoTakingHelper?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
