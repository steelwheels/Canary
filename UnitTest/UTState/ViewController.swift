//
//  ViewController.swift
//  UTState
//
//  Created by Tomoo Hamada on 2016/02/24.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		print("UnitTest: Console")
		UTConsoleTest()
		
		print("UnitTest: Tristate")
		UTTristateTest()
		
		print("UnitTest: State")
		UTStateTest()
		
		print("UnitTest: List")
		UTList()
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

