//
//  ViewController.swift
//  UTFileManager
//
//  Created by Tomoo Hamada on 2016/01/07.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import Canary

class ViewController: NSViewController
{
	@IBOutlet weak var loadButton: NSButton!
	@IBOutlet weak var saveButton: NSButton!
	@IBOutlet weak var statusButton: NSButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func loadButtonPressed(sender: AnyObject) {
		CNPercistentURL.openPanel("OpenPanel", relativeURL: nil, doPersistent: true,
		  callback: {(result: CNPercistentURL?) -> Void in
			if let url = result {
				print("loadButtonPressed: \(url.description)")
			} else {
				print("loadButtonPressed: nil")
			}
		})
	}

	@IBAction func saveButtonPressed(sender: AnyObject) {
		CNPercistentURL.savePanel("SavePanel", outputDirectory: nil, relativeURL: nil, doPersistent: true,
		  callback: { (result : CNPercistentURL?) -> Void in
			if let url = result {
				print("saveButtonPressed: \(url.description)")
			} else {
				print("saveButtonPressed: nil")
			}
		})
	}

	@IBAction func statusButtonPressed(sender: AnyObject) {
		let urls = CNBookmarkPreference.URLs
		print("status {")
		for url in urls {
			print(" \(url.path)")
		}
		print("}")
	}
	
}

