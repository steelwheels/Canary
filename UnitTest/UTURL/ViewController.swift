//
//  ViewController.swift
//  UTURL
//
//  Created by Tomoo Hamada on 2016/02/05.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var getRelativeURLButton: NSButton!
	@IBOutlet weak var loadContentsButton: NSButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func getRelativeURLButtonPressed(sender: AnyObject) {
		relativePathTest("/Users/someone/Documents/BattleFieldCode/script/a.js",
		  base: "/Users/someone/Documents/BattleFieldCode/team")
	}
	
	@IBAction func loadContentsButtonPressed(sender: AnyObject) {
		NSURL.openPanel("load contents", fileTypes: nil, openFileCallback: { (results: Array<NSURL>) -> Void in
			for url in results {
				print("URL: \(url.path)")
				let (context, error) = url.loadContents()
				if let err = error {
					print("ERROR -> \(err.toString())")
				} else {
					print("CONTENT -> \(context)")
				}
			}
		})
	}
}

