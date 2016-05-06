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
		NSURL.openPanel("OpenPanel", fileTypes: [],
		  openFileCallback: {(result: Array<NSURL>) -> Void in
			print("loadButtonPressed: \(result.description)")
			self.dumpURL(result)
		})
	}

	@IBAction func saveButtonPressed(sender: AnyObject) {
		NSURL.savePanel("SavePanel", outputDirectory: nil,
		  saveFileCallback: { (result : NSURL) -> Bool in
			let content = NSString(string: "a")
			do {
				try content.writeToURL(result, atomically: false, encoding: NSUTF8StringEncoding)
				return true
			}
			catch {
				NSLog("saveButtonPressed: can not write")
			}
			return false
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

	private func dumpURL(URLs: Array<NSURL>){
		for url in URLs {
			let (text, error) = url.loadContents()
			if let err = error {
				print("context: Error: \(err.toString)")
			} else {
				print("context: \"\(text)\"")
			}
		}
	}
}

