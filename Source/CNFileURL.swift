/*
 * @file	CNFileURL.swift
 * @brief	Extend CNFileURL class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class CNFileURL
{
	public var mainURL : NSURL

	public init(mainURL murl: NSURL){
		mainURL		= murl
	}

	public var description : String {
		get {
			var mainstr = "nil"
			if let str = mainURL.path {
				mainstr = str
			}
			return "{URL:" + mainstr + "}"
		}
	}

	public var URL : NSURL {
		get	{ return mainURL }
	}

	public func stringWithContentsOfURL() -> String? {
		var result : String?
		mainURL.startAccessingSecurityScopedResource()
		do {
			let string = try NSString(contentsOfURL: mainURL, encoding: NSUTF8StringEncoding)
			result = String(string)
		}
		catch {
			result = nil
		}
		mainURL.stopAccessingSecurityScopedResource()
		return result
	}

	public func saveToUserDefaults(relativeURL: NSURL?) {
		let preference = CNBookmarkPreference.sharedPreference
		preference.saveToUserDefaults(mainURL: mainURL, relativeURL: relativeURL)
	}

	public class func openPanel(title : String, fileTypes types: Array<String>?, openFileCallback: (result: CNFileURL) -> Void)
	{
		let panel = NSOpenPanel()
		panel.title = title
		panel.canChooseDirectories = false
		panel.allowsMultipleSelection = false
		panel.allowedFileTypes = types
		panel.beginWithCompletionHandler({ (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {
				let mainurl = panel.URLs[0]
				let newurl = CNFileURL(mainURL: mainurl)
				openFileCallback(result: newurl)
			}
		})
	}

	public class func savePanel(title : String, outputDirectory outdir: NSURL?, saveFileCallback: (result: CNFileURL) -> Void)
	{
		let panel = NSSavePanel()
		panel.title = title
		panel.canCreateDirectories = true
		panel.showsTagField = false
		if let odir = outdir {
			panel.directoryURL = odir
		}
		panel.beginWithCompletionHandler({ (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {
				if let mainurl = panel.URL {
					let newurl = CNFileURL(mainURL: mainurl)
					saveFileCallback(result: newurl)
				}
			}
		})
	}
	
	public class func relativePath(sourceURL src: NSURL, baseDirectory base: NSURL) -> NSURL {
		if let srccomp = src.pathComponents, basecomp = base.pathComponents {
			let common = findLastCommonComponent(srccomp, s1array: basecomp)
			if common > 0 {
				var resultpath = ""
				let updirs = basecomp.count - common
				for var i=0 ; i<updirs ; i++ {
					resultpath = "../" + resultpath
				}
				for comp in common ... srccomp.count-1 {
					resultpath = resultpath + "/" + srccomp[comp]
				}
				return NSURL(fileURLWithPath: resultpath)
			}
		}
		return src
	}
	
	private class func findLastCommonComponent(s0array: Array<String>, s1array: Array<String>) -> Int {
		let s0count = s0array.count
		let s1count = s1array.count
		let count   = s0count < s1count ? s0count : s1count
		for var i:Int=0 ; i<count ; i++ {
			if s0array[i] != s1array[i] {
				return i
			}
		}
		return count - 1
	}
}
