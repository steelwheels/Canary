/*
 * @file	CNFileBookmark.swift
 * @brief	Extend CNFileBookmark class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNPercistentURL
{
	public var mainURL		: NSURL?
	public var relativeURL		: NSURL?
	
	public init(mainURL murl: NSURL, relativeURL rurl : NSURL?){
		mainURL		= murl
		relativeURL	= rurl
	}

	public var description : String {
		get {
			var mainstr = "nil"
			var relstr  = "nil"
			if let url = mainURL {
				if let str = url.path {
					mainstr = str
				}
			}
			if let url = relativeURL {
				if let str = url.path {
					relstr = str
				}
			}
			return "{main:" + mainstr + ", relative:" + relstr + "}"
		}
	}
	
	public func stringWithContentsOfURL() -> String? {
		if let url = mainURL {
			var result : String?
			url.startAccessingSecurityScopedResource()
			do {
				let string = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
				result = String(string)
			}
			catch {
				result = nil
			}
			url.stopAccessingSecurityScopedResource()
			return result
		} else {
			return  nil ;
		}
	}
	
	public class func openPanel(title : String, fileTypes types: Array<String>?, relativeURL relurl: NSURL?, doPersistent: Bool, callback: (result: CNPercistentURL?) -> Void)
	{
		let panel = NSOpenPanel()
		panel.title = title
		panel.canChooseDirectories = false
		panel.allowsMultipleSelection = false
		panel.allowedFileTypes = types
		panel.beginWithCompletionHandler({ (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {
				let mainurl = panel.URLs[0]
				let newurl = CNPercistentURL(mainURL: mainurl, relativeURL: relurl)
				if doPersistent {
					let preference = CNBookmarkPreference.sharedPreference
					preference.saveToUserDefaults(mainURL: mainurl, relativeURL: relurl)
				}
				callback(result: newurl)
			} else {
				callback(result: nil)
			}
		})
	}
	
	public class func savePanel(title : String, outputDirectory outdir: NSURL?, relativeURL relurl: NSURL?, doPersistent: Bool, callback: (result: CNPercistentURL?) -> Void)
	{
		let panel = NSSavePanel()
		panel.title = title
		panel.canCreateDirectories = true
		if let odir = outdir {
			panel.directoryURL = odir
		}
		panel.beginWithCompletionHandler({ (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {
				if let mainurl = panel.URL {
					let newurl = CNPercistentURL(mainURL: mainurl, relativeURL: relurl)
					if doPersistent {
						let preference = CNBookmarkPreference.sharedPreference
						preference.saveToUserDefaults(mainURL: mainurl, relativeURL: relurl)
					}
					callback(result: newurl)
				} else {
					callback(result: nil)
				}
			} else {
				callback(result: nil)
			}
		})
	}
}
