//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Parth Shah on 24/06/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
	
	// View controller on which AlertViewController and UIImagePickerController are presented
	weak var viewController: UIViewController!
	var callBack: PhotoTakingHelperCallback
	var imagePickerController: UIImagePickerController?
	
	init(viewController: UIViewController, callBack: PhotoTakingHelperCallback) {
		self.viewController = viewController
		self.callBack = callBack
		
		super.init()
		
		showPhotoSourceSelection()
	}
	
	func showPhotoSourceSelection(){
		// Allow user to choose between photo library and camera
		let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		alertController.addAction(cancelAction)
		
		let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
			self.showImagePickerController(.PhotoLibrary)
		}
		alertController.addAction(photoLibraryAction)
		
		if (UIImagePickerController.isCameraDeviceAvailable(.Rear)){
			let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
				self.showImagePickerController(.Camera)
			}
			alertController.addAction(cameraAction)
		}
		
		viewController.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func showImagePickerController(sourceType: UIImagePickerControllerSourceType){
		imagePickerController = UIImagePickerController()
		imagePickerController?.sourceType = sourceType
		imagePickerController?.delegate = self
		self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
	}
	
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		viewController.dismissViewControllerAnimated(false, completion: nil)
		
		callBack(image)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		viewController.dismissViewControllerAnimated(true, completion: nil)
	}
	
}
