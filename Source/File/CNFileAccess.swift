/**
 * @file	CNFileAccess.swift
 * @brief	Extend CNFileAccess class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class CNFileAccess
{
	public class func selectInputFile(title: String, callback: (file: NSURL) -> Void){
		let panel = NSOpenPanel()
		panel.title = title
		panel.canChooseDirectories = false
		panel.allowsMultipleSelection = false
		panel.beginWithCompletionHandler({ (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {
				let url = (panel.URLs)[0]
				callback(file: url)
			}
		})
	}
	
}

