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
	@IBOutlet weak var clearButton: NSButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let home = CNFilePath.URLForHomeDirectory()
		print("home = \(home.absoluteString)")
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func loadButtonPressed(sender: AnyObject) {
		CNFileURL.openPanel("OpenPanel", fileTypes: [],
		  openFileCallback: {(result: CNFileURL) -> Void in
			print("loadButtonPressed: \(result.description)")
			self.dumpURL(result)
			result.saveToUserDefaults(nil)
		})
	}

	@IBAction func saveButtonPressed(sender: AnyObject) {
		CNFileURL.savePanel("SavePanel", outputDirectory: nil,
		  saveFileCallback: { (result : CNFileURL) -> Void in
			let content = NSString(string: "a")
			do {
				try content.writeToURL(result.mainURL, atomically: false, encoding: NSUTF8StringEncoding)
				result.saveToUserDefaults(nil)
			}
			catch {
				NSLog("saveButtonPressed: can not write")
			}
			
		})
	}

	@IBAction func statusButtonPressed(sender: AnyObject) {
		let preference = CNBookmarkPreference.sharedPreference
		preference.dump()
		preference.synchronize()
	}
	
	@IBAction func clearButtonPressed(sender: AnyObject) {
		let preference = CNBookmarkPreference.sharedPreference
		preference.clear()
		preference.synchronize()
	}

	private func dumpURL(url: CNFileURL){
		let textp = url.stringWithContentsOfURL()
		if let text = textp {
			print("context: \"\(text)\"")
		} else {
			print("context: nil")
		}
	}
}

