/*
 * @file	CNFileURL.swift
 * @brief	Extend CNFileURL class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public extension NSURL
{
	public class func openPanel(title : String, fileTypes types: Array<String>?, openFileCallback: (result: Array<NSURL>) -> Void)
	{
		let panel = NSOpenPanel()
		panel.title = title
		panel.canChooseDirectories = false
		panel.allowsMultipleSelection = false
		panel.allowedFileTypes = types
		panel.beginWithCompletionHandler({ (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton {

				let preference = CNBookmarkPreference.sharedPreference
				preference.saveToUserDefaults(URLs: panel.URLs)
				preference.synchronize()

				openFileCallback(result: panel.URLs)
			}
		})
	}

	public class func savePanel(title : String, outputDirectory outdir: NSURL?, saveFileCallback: (result: NSURL) -> Bool)
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
				if let newurl = panel.URL {
					if saveFileCallback(result: newurl) {
						let preference = CNBookmarkPreference.sharedPreference
						preference.saveToUserDefaults(URL: newurl)
						preference.synchronize()
					}
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
				var is1st : Bool = true
				for comp in common ... srccomp.count-1 {
					if is1st {
						is1st = false
					} else {
						resultpath = resultpath + "/"
					}
					resultpath = resultpath + srccomp[comp]
				}
				return NSURL(fileURLWithPath: resultpath)
			}
		}
		return src
	}

	public func loadContents() -> (NSString?, NSError?) {
		if startAccessingSecurityScopedResource() {
			do {
				let contents = try NSString(contentsOfURL: self, encoding: NSUTF8StringEncoding)
				stopAccessingSecurityScopedResource()
				return (contents, nil)
			}
			catch {
				stopAccessingSecurityScopedResource()
				let error = NSError.fileError("Can not access: \(path)")
				return (nil, error)
			}
		} else {
			let error = NSError.fileError("Can not access: \(path)")
			return (nil, error)
		}
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

