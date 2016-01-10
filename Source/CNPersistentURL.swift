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
	
	public func key() -> String? {
		if let url = mainURL {
			return url.path
		} else {
			return nil
		}
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
	
	public class func openPanel(title : String, relativeURL relurl: NSURL?, doPersistent: Bool, callback: (result: CNPercistentURL?) -> Void)
	{
		let panel = NSOpenPanel()
		panel.title = title
		panel.canChooseDirectories = false
		panel.allowsMultipleSelection = false
		panel.beginWithCompletionHandler({ (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {
				let mainurl = panel.URLs[0]
				let newurl = CNPercistentURL(mainURL: mainurl, relativeURL: relurl)
				if doPersistent {
					saveToUserDefaults(mainURL: mainurl, relativeURL: relurl)
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
						saveToUserDefaults(mainURL: mainurl, relativeURL: relurl)
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
	
	public class func loadFromPreference() -> Array<CNPercistentURL> {
		var result : Array<CNPercistentURL> = []
		let mainurls = CNBookmarkPreference.mainURLs
		for mainurl in mainurls {
			if let newurl = loadFromUserDefaults(mainURL: mainurl) {
				result.append(newurl)
			}
		}
		return result
	}
	
	private class func saveToUserDefaults(mainURL main: NSURL, relativeURL relurl: NSURL?) -> NSError?
	{
		do {
			let data = try main.bookmarkDataWithOptions(.WithSecurityScope, includingResourceValuesForKeys: nil, relativeToURL: relurl)
			let bookmark = CNBookmark(relativeURL: relurl, bookmark: data)
			return CNBookmarkPreference.addBookmark(mainURL: main, bookmark: bookmark)
		}
		catch {
			return NSError.fileError("Can not generate bookmark: \(main.description)")
		}
	}

	private class func loadFromUserDefaults(mainURL main: NSURL) -> CNPercistentURL? {
		if let bookmark = CNBookmarkPreference.bookmark(mainURL: main)  {
			let relurl = bookmark.relativeURL
			var isstale:ObjCBool = false;
			do {
				let data   = bookmark.bookmark
				let newurl = try NSURL(byResolvingBookmarkData: data, options: .WithSecurityScope, relativeToURL: relurl, bookmarkDataIsStale: &isstale)
				if isstale {
					saveToUserDefaults(mainURL: newurl, relativeURL: relurl)
				}
				let result = CNPercistentURL(mainURL: newurl, relativeURL: relurl)
				result.relativeURL = relurl
				return result
			}
			catch {
				/* Some error occured */
			}
		}
		return nil
	}
}
